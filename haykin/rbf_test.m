function y = rbf_test(w, x, t, sigma)

% function y = rbf_test(w, x, t, sigma)
%
%  Tests a regularized radial basis function network
%  
%    The input structure RBF must be of the format defined in rbf.m
%    Do a 'help rbf' to see the structure.
%
%    x - test data
%    t - centers
%    w - weights
%
% Hugh Pasika 1998

rx = size(x,1);

G = rbf_mkGF(x,t);
G = exp((-1/(2*sigma^2))*G.^2);
G = [G ones(rx,1)];

y = G*w;


