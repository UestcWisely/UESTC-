function K = linear_kernel(u,v,varargin) %#ok
%LINEAR_KERNEL linear kernel for SVM functions

% Copyright 2004 The MathWorks, Inc.

K = (u*v');
