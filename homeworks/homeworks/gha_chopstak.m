function D=gha_chopstak(P,rm,cm)

% function D=gha_chopstak(P,rm,cm)
%
%  this routine takes an image and reduces breaks it into pattern vectors
%  appropriate for block transform coding
%
%  P - image to be processed
%  rm - rows in block
%  cm - columns in block
%
% Hugh Pasika 1997

p=rm*cm; 	[rP cP]=size(P);
r=floor(rP/rm); c=floor(cP/cm);
D=zeros(r*c,p); E=P*0;

for i=1:r, 
   for j=1:c,
      x=P( (i-1)*rm+1:i*rm , (j-1)*cm+1:j*cm ); x=x(:)';
      row=(i-1)*r+j;
      F(row,:)=[ (i-1)*rm+1 i*rm  (j-1)*cm+1 j*cm ];
      D(row,:)=x;
   end
end






