function [s, count, M]=hop_test(W,x,update)

% function [s, count, M]=hop_test(W,x,update)
%
%   s - output state vector
%   count - number of cyckes until stable state is reached
%   M - matrix containing the intermediate network states
%   W - weight matrix
%   x - probe vector
%   update - how often to view the network
%   
% Hugh Pasika 1997

% initialize a few variables
[r c]=size(x);  s_prev=x(:);  N=r*c;  count=0; M=zeros(120,1);

% the next 5 lines determine if interim plotting is to be done
if update > 0, 
    plot='on '; 
else
    plot='off'; update=1; % set update to prevent divide by zero error later
end

% the upper limit in the loop is arbitrary (you'll never reach it)
while count < 1000,
    ind=1; clear ch;

  % store the network state
    	count=count+1;
  	M(:,count)=s_prev;

  % vector will declare which neurons want to change
    for j=1:120,
        nv(j)=sgn(sum(W(j,:)'.*s_prev));
        if abs(nv(j)-s_prev(j)) > 0, ch(ind)=j; ind=ind+1; end;
    end


  % now, do any neurons want to change? if no, break out of the loop 
    if ind==1, break; end
  % update one neuron
    r_ind=ceil(rand(1)*length(ch));  % select one neuron for updating
    s_prev(ch(r_ind))=s_prev(ch(r_ind))*(-1);    % update it

  % the next 6 lines are more plotting directives to show intermediate stages
    if (plot == 'on ') & floor(count/update) == (count/update) ;
	hop_plotdig(s_prev,12,10,'Current State');
        fprintf(1,'\nThe current iteration is: %4.0f \n',count);
        fprintf(1,'Hit any key to continue. \n')
        pause
    end
    
end

% more plotting directives
if (plot == 'on '), 
  hop_plotdig(s_prev,12,10,'Final State');
  fprintf(1,'\nTraining stopped after %4.0f iterations.\n',count);
end

% storage of stable state
M(:,count)=s_prev; 
s=reshape(s_prev,r,c);
