function [G, n, m] = rbf_mkGF(x,t)

% function [G, n, m] = rbf_mkGF(x,t)
%
%  makes a precursor to the Green's function matrix
%  x - data
%  t - centers
%
%  G - matrix 
%  n/m - G's dimensions
%
% Hugh Pasika 1997

[rx cx] = size(x);	[rt ct] = size(t);
if cx ~= ct, disp('dimensions of centers and data do not match'); break; end
n = rx; 		 m  = rt;
G = zeros(n,m);

for i=1:n,
   xt=x(i,:);
   G(i,:) = sqrt((sum((xt(ones(m,1),:)-t).^2,2)))';
end


