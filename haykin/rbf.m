function w = rbf(x, t, d, sigma, lam)

% function w = rbf(x,t,d,sigma,lam)
%
%  Determines weights for a regularized radial basis function network.
%  
% 	x     - data
% 	t     - centers
% 	d     - desired response
% 	sigma - spread of centers
% 	lam   - regularization parameter, set to 'opt' for opt. value via gcv
%
% Hugh Pasika 1997
%

[rx cx] = size(x);      [rt ct] = size(t);
if cx ~= ct, disp('dimensions of centers and data do not match'); break; end
n = rx;  m = rt;

G = rbf_mkGF(x,t);
G = exp((-1/(2*sigma^2))*G.^2);
G = G + lam*eye(size(G));
G = [G ones(rx,1)];

w = pinv(G)*d;
