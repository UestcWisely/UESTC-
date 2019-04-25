function [P, flip]=hop_flip(P, prob, seed)

% function [P, flip]=hop_flip(P, prob, seed)
%
% this routine randomly flips bits in the input pattern (P) according to the
% user specified probability
%
% Hugh Pasika 1997


[r c]=size(P);  P=P(:);  flip=0;

for i=1:r*c,
    v=rand(1);
    if v <= prob,
	flip=flip+1;
        P(i)=P(i)*(-1);
    end
end

P=reshape(P,r,c);
