function [svm_struct, svIndex] = svmtrain(training, groupnames, varargin)
%SVMTRAIN trains a support vector machine classifier
%
%   SVMStruct = SVMTRAIN(TRAINING,GROUP) trains a support vector machine
%   classifier using data TRAINING taken from two groups given by GROUP.
%   SVMStruct contains information about the trained classifier that is
%   used by SVMCLASSIFY for classification. GROUP is a column vector of
%   values of the same length as TRAINING that defines two groups. Each
%   element of GROUP specifies the group the corresponding row of TRAINING
%   belongs to. GROUP can be a numeric vector, a string array, or a cell
%   array of strings. SVMTRAIN treats NaNs or empty strings in GROUP as
%   missing values and ignores the corresponding rows of TRAINING.
%
%   SVMTRAIN(...,'KERNEL_FUNCTION',KFUN) allows you to specify the kernel
%   function KFUN used to map the training data into kernel space. The
%   default kernel function is the dot product. KFUN can be one of the
%   following strings or a function handle:
%
%       'linear'      Linear kernel or dot product
%       'quadratic'   Quadratic kernel
%       'polynomial'  Polynomial kernel (default order 3)
%       'rbf'         Gaussian Radial Basis Function kernel
%       'mlp'         Multilayer Perceptron kernel (default scale 1)
%       function      A kernel function specified using @,
%                     for example @KFUN, or an anonymous function
%
%   A kernel function must be of the form
%
%         function K = KFUN(U, V)
%
%   The returned value, K, is a matrix of size M-by-N, where U and V have M
%   and N rows respectively.  If KFUN is parameterized, you can use
%   anonymous functions to capture the problem-dependent parameters. For
%   example, suppose that your kernel function is
%
%       function k = kfun(u,v,p1,p2)
%       k = tanh(p1*(u*v')+p2);
%
%   You can set values for p1 and p2 and then use an anonymous function:
%       @(u,v) kfun(u,v,p1,p2).
%
%   SVMTRAIN(...,'POLYORDER',ORDER) allows you to specify the order of a
%   polynomial kernel. The default order is 3.
%
%   SVMTRAIN(...,'MLP_PARAMS',[P1 P2]) allows you to specify the
%   parameters of the Multilayer Perceptron (mlp) kernel. The mlp kernel
%   requires two parameters, P1 and P2, where K = tanh(P1*U*V' + P2) and P1
%   > 0 and P2 < 0. Default values are P1 = 1 and P2 = -1.
%
%   SVMTRAIN(...,'METHOD',METHOD) allows you to specify the method used
%   to find the separating hyperplane. Options are
%
%       'QP' Use quadratic programming (requires the Optimization Toolbox)
%       'LS' Use least-squares method
%
%   If you have the Optimization Toolbox, then the QP method is the default
%   method. If not, the only available method is LS.
%
%   SVMTRAIN(...,'QUADPROG_OPTS',OPTIONS) allows you to pass an OPTIONS
%   structure created using OPTIMSET to the QUADPROG function when using
%   the 'QP' method. See help optimset for more details.
%
%   SVMTRAIN(...,'SHOWPLOT',true), when used with two-dimensional data,
%   creates a plot of the grouped data and plots the separating line for
%   the classifier.
%
%   Example:
%       % Load the data and select features for classification
%       load fisheriris
%       data = [meas(:,1), meas(:,2)];
%       % Extract the Setosa class
%       groups = ismember(species,'setosa');
%       % Randomly select training and test sets 
%       [train, test] = crossvalind('holdOut',groups);
%       cp = classperf(groups);
%       % Use a linear support vector machine classifier
%       svmStruct = svmtrain(data(train,:),groups(train),'showplot',true);
%       classes = svmclassify(svmStruct,data(test,:),'showplot',true);
%       % See how well the classifier performed
%       classperf(cp,classes,test);
%       cp.CorrectRate
%
%   See also CLASSIFY, KNNCLASSIFY, QUADPROG, SVMCLASSIFY.

%   Copyright 2004 The MathWorks, Inc.
%   $Revision: 1.1.12.1 $  $Date: 2004/12/24 20:43:35 $

%   References:
%     [1] Kecman, V, Learning and Soft Computing,
%         MIT Press, Cambridge, MA. 2001.
%     [2] Suykens, J.A.K., Van Gestel, T., De Brabanter, J., De Moor, B.,
%         Vandewalle, J., Least Squares Support Vector Machines,
%         World Scientific, Singapore, 2002.
%     [3] Scholkopf, B., Smola, A.J., Learning with Kernels,
%         MIT Press, Cambridge, MA. 2002.

%
%   SVMTRAIN(...,'KFUNARGS',ARGS) allows you to pass additional
%   arguments to kernel functions.

% set defaults


plotflag = false;
qp_opts = [];
kfunargs = {};
setPoly = false; usePoly = false;
setMLP = false; useMLP = false;
if ~isempty(which('quadprog'))
    useQuadprog = true;
else
    useQuadprog = false;
end
% set default kernel function
kfun = @linear_kernel;

% check inputs
if nargin < 2
    error(nargchk(2,Inf,nargin))
end

numoptargs = nargin -2;
optargs = varargin;

% grp2idx sorts a numeric grouping var ascending, and a string grouping
% var by order of first occurrence

[g,groupString] = grp2idx(groupnames);

% check group is a vector -- though char input is special...
if ~isvector(groupnames) && ~ischar(groupnames)
    error('Bioinfo:svmtrain:GroupNotVector',...
        'Group must be a vector.');
end

% make sure that the data is correctly oriented.
if size(groupnames,1) == 1
    groupnames = groupnames';
end
% make sure data is the right size
n = length(groupnames);
if size(training,1) ~= n
    if size(training,2) == n
        training = training';
    else
        error('Bioinfo:svmtrain:DataGroupSizeMismatch',...
            'GROUP and TRAINING must have the same number of rows.')
    end
end

% NaNs are treated as unknown classes and are removed from the training
% data
nans = find(isnan(g));
if length(nans) > 0
    training(nans,:) = [];
    g(nans) = [];
end
ngroups = length(groupString);

if ngroups > 2
    error('Bioinfo:svmtrain:TooManyGroups',...
        'SVMTRAIN only supports classification into two groups.\nGROUP contains %d different groups.',ngroups)
end
% convert to 1, -1.
g = 1 - (2* (g-1));

% handle optional arguments

if  numoptargs >= 1
    if rem(numoptargs,2)== 1
        error('Bioinfo:svmtrain:IncorrectNumberOfArguments',...
            'Incorrect number of arguments to %s.',mfilename);
    end
    okargs = {'kernel_function','method','showplot','kfunargs','quadprog_opts','polyorder','mlp_params'};
    for j=1:2:numoptargs
        pname = optargs{j};
        pval = optargs{j+1};
        k = strmatch(lower(pname), okargs);%#ok
        if isempty(k)
            error('Bioinfo:svmtrain:UnknownParameterName',...
                'Unknown parameter name: %s.',pname);
        elseif length(k)>1
            error('Bioinfo:svmtrain:AmbiguousParameterName',...
                'Ambiguous parameter name: %s.',pname);
        else
            switch(k)
                case 1  % kernel_function
                    if ischar(pval)
                        okfuns = {'linear','quadratic',...
                            'radial','rbf','polynomial','mlp'};
                        funNum = strmatch(lower(pval), okfuns);%#ok
                        if isempty(funNum)
                            funNum = 0;
                        end
                        switch funNum  %maybe make this less strict in the future
                            case 1
                                kfun = @linear_kernel;
                            case 2
                                kfun = @quadratic_kernel;
                            case {3,4}
                                kfun = @rbf_kernel;
                            case 5
                                kfun = @poly_kernel;
                                usePoly = true;
                            case 6
                                kfun = @mlp_kernel;
                                useMLP = true;
                            otherwise
                                error('Bioinfo:svmtrain:UnknownKernelFunction',...
                                    'Unknown Kernel Function %s.',kfun);
                        end
                    elseif isa (pval, 'function_handle')
                        kfun = pval;
                    else
                        error('Bioinfo:svmtrain:BadKernelFunction',...
                            'The kernel function input does not appear to be a function handle\nor valid function name.')
                    end
                case 2  % method
                    if strncmpi(pval,'qp',2)
                        useQuadprog = true;
                        if isempty(which('quadprog'))
                            warning('Bioinfo:svmtrain:NoOptim',...
                                'The Optimization Toolbox is required to use the quadratic programming method.')
                            useQuadprog = false;
                        end
                    elseif strncmpi(pval,'ls',2)
                        useQuadprog = false;
                    else
                        error('Bioinfo:svmtrain:UnknownMethod',...
                            'Unknown method option %s. Valid methods are ''QP'' and ''LS''',pval);

                    end
                case 3  % display
                    if pval ~= 0
                        if size(training,2) == 2
                            plotflag = true;
                        else
                            warning('Bioinfo:svmtrain:OnlyPlot2D',...
                                'The display option can only plot 2D training data.')
                        end

                    end
                case 4 % kfunargs
                    if iscell(pval)
                        kfunargs = pval;
                    else
                        kfunargs = {pval};
                    end
                case 5 % quadprog_opts
                    if isstruct(pval)
                        qp_opts = pval;
                    elseif iscell(pval)
                        qp_opts = optimset(pval{:});
                    else
                        error('Bioinfo:svmtrain:BadQuadprogOpts',...
                            'QUADPROG_OPTS must be an opts structure.');
                    end
                case 6 % polyorder
                    if ~isscalar(pval) || ~isnumeric(pval)
                        error('Bioinfo:svmtrain:BadPolyOrder',...
                            'POLYORDER must be a scalar value.');
                    end
                    if pval ~=floor(pval) || pval < 1
                        error('Bioinfo:svmtrain:PolyOrderNotInt',...
                            'The order of the polynomial kernel must be a positive integer.')
                    end
                    kfunargs = {pval};
                    setPoly = true;

                case 7 % mlpparams
                    if numel(pval)~=2
                        error('Bioinfo:svmtrain:BadMLPParams',...
                            'MLP_PARAMS must be a two element array.');
                    end
                    if ~isscalar(pval(1)) || ~isscalar(pval(2))
                        error('Bioinfo:svmtrain:MLPParamsNotScalar',...
                            'The parameters of the multi-layer perceptron kernel must be scalar.');
                    end
                    kfunargs = {pval(1),pval(2)};
                    setMLP = true;
            end
        end
    end
end
if setPoly && ~usePoly
    warning('Bioinfo:svmtrain:PolyOrderNotPolyKernel',...
        'You specified a polynomial order but not a polynomial kernel');
end
if setMLP && ~useMLP
    warning('Bioinfo:svmtrain:MLPParamNotMLPKernel',...
        'You specified MLP parameters but not an MLP kernel');
end
% plot the data if requested
if plotflag
    [hAxis,hLines] = svmplotdata(training,g);
    legend(hLines,cellstr(groupString));
end

% calculate kernel function
try
    kx = feval(kfun,training,training,kfunargs{:});
    % ensure function is symmetric
    kx = (kx+kx')/2;
catch
    error('Bioinfo:svmtrain:UnknownKernelFunction',...
        'Error calculating the kernel function:\n%s\n', lasterr);
end
% create Hessian
% add small constant eye to force stability
H =((g*g').*kx) + sqrt(eps(class(training)))*eye(n);

if useQuadprog
    % The large scale solver cannot handle this type of problem, so turn it
    % off.
    qp_opts = optimset(qp_opts,'LargeScale','Off');
    % X=QUADPROG(H,f,A,b,Aeq,beq,LB,UB,X0,opts)
    alpha = quadprog(H,-ones(n,1),[],[],...
        g',0,zeros(n,1),inf *ones(n,1),zeros(n,1),qp_opts);

    % The support vectors are the non-zeros of alpha
    svIndex = find(alpha > sqrt(eps));
    sv = training(svIndex,:);

    % calculate the parameters of the separating line from the support
    % vectors.
    alphaHat = g(svIndex).*alpha(svIndex);

    % Calculate the bias by applying the indicator function to the support
    % vector with largest alpha.
    [maxAlpha,maxPos] = max(alpha); %#ok
    bias = g(maxPos) - sum(alphaHat.*kx(svIndex,maxPos));
    % an alternative method is to average the values over all support vectors
    % bias = mean(g(sv)' - sum(alphaHat(:,ones(1,numSVs)).*kx(sv,sv)));

    % An alternative way to calculate support vectors is to look for zeros of
    % the Lagrangians (fifth output from QUADPROG).
    %
    % [alpha,fval,output,exitflag,t] = quadprog(H,-ones(n,1),[],[],...
    %             g',0,zeros(n,1),inf *ones(n,1),zeros(n,1),opts);
    %
    % sv = t.lower < sqrt(eps) & t.upper < sqrt(eps);
else  % Least-Squares
    % now build up compound matrix for solver

    A = [0 g';g,H];
    b = [0;ones(size(g))];
    x = A\b;

    % calculate the parameters of the separating line from the support
    % vectors.
    sv = training;
    bias = x(1);
    alphaHat = g.*x(2:end);
end

svm_struct.SupportVectors = sv;
svm_struct.Alpha = alphaHat;
svm_struct.Bias = bias;
svm_struct.KernelFunction = kfun;
svm_struct.KernelFunctionArgs = kfunargs;
svm_struct.GroupNames = groupnames;
svm_struct.FigureHandles = [];
if plotflag 
    hSV = svmplotsvs(hAxis,svm_struct);
    svm_struct.FigureHandles = {hAxis,hLines,hSV};
end



