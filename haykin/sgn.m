function B=sgn(A)

% function B=sgn(A)
%
%  This is the straight sgn function to be used in the HopFiled test
%  experiments.
%
% Hugh Pasika 1997

B = (A(:,:)>0) + (A(:,:)<0)*(-1);

