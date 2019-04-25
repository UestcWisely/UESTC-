function I=gha_recompose(coeffs,W,mval)

% I=recompose(coeffs,W,mval)
%
% coeffs - decomposition coefficents as determined via gha_getcoeffs.m
%
% mval scales the final output in the following line
%    I=gha_unchopst(imdat*mval, r, c, 8, 8);
% so if you want things to remain as normal, set mval = 1
%
% Hugh Pasika 1997

[rW, cW] = size(W);

r = 32;  c = 32;  xdir = 8; ydir = 8;

for i=1:r,
   for j=1:c,
      g=coeffs((i-1)*r+j,:)'; CA=g(:,ones(1,rW))';
      CB=sum((CA.*W(:,:))')'; imdat((i-1)*r+j,:)=CB';
   end
end

I=gha_unchopst(imdat*mval, r, c, 8, 8);
