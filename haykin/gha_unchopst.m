function I=gha_unchopst(X,r,c,rm,cm)

% function I=gha_unchopst(X,r,c,rm,cm)
%
% routine to rebuild the image out of the column vectors of X which the unfolded
% blocks pulled out in gha_chopstak.m
%
% X - columns vectors to form blocks
% r  - blocks per column
% c  - blocks per row
% rm - rows in block
% cm - columns in block
%
% Hugh Pasika 1997

I=zeros(r*rm,c*cm);

for i=1:r,
   for j=1:c,
      row=(i-1)*r+j;  x=X(row, :);
      I( (i-1)*rm+1:i*rm , (j-1)*cm+1:j*cm )=reshape(x,8,8);
   end
end

