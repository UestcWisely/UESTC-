function kval = rbf_kernel(u,v,varargin)%#ok
%RBF_KERNEL radial basis function kernel for SVM functions

% Copyright 2004 The MathWorks, Inc.

kval = exp(-0.5*(repmat(sqrt(sum(u.^2,2).^2),1,size(v,1))...
    -2*(u*v')+repmat(sqrt(sum(v.^2,2)'.^2),size(u,1),1)));