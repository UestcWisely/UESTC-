function [cor, uncor, O, dec]=bpm_test(W1,b1,W2,b2,P)

% [cor, uncor, O, dec]=bpm_test(W1,b1,W2,b2,P)
%
%   c   - vectors of ones and zeros - one if the output class is correct
%   d   - actual class outputs
%   O   - raw outputs
%   dec - class decision
%
% Hugh Pasika 1997

[pats cP]=size(P);

for i=1:pats,
   input  = P(i,1:2)';
   target = P(i,2+1:2+2)';
   outHiddenLayer = bpm_phi(W1*input+b1);
   outOutputLayer = bpm_phi(W2*outHiddenLayer+b2);
   O(i,1:2)	  = outOutputLayer';

end

dec=(O(:,1) < O(:,2));

n_uncor=(sum(abs(dec-P(:,5))));
uncor=(sum(abs(dec-P(:,5)))/pats)*100;
cor=((pats-n_uncor)/pats)*100;

fprintf(1,'\n   percent correct: %g   percent incorrect: %g\n\n',cor, uncor)
