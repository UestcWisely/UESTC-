function K = quadratic_kernel(u,v,varargin)%#ok
%QUADRATIC_KERNEL quadratic kernel for SVM functions

% Copyright 2004 The MathWorks, Inc.

dotproduct = (u*v');
K = dotproduct.*(1 + dotproduct);
