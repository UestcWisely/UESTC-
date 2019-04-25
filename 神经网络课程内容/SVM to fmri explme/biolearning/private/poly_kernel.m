function K = poly_kernel(u,v,N,varargin)%#ok
%POLY_KERNEL polynomial kernel for SVM functions

% Copyright 2004 The MathWorks, Inc.

if nargin < 3 || isempty(N)
    N = 3;
end

dotproduct = (u*v');

K = dotproduct;

for i = 2:N
    K = K.*(1 + dotproduct);
end
