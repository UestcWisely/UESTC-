function coeffs=gha_getcoeffs(Orig,W,plot_flg)

% function coeffs=gha_getcoeffs(Orig,W,plot_flg)
%
%  Orig - original image
%  W    - weights
%  
%  if plot_flg is present (any value), plots of the original image,
%     the masks and the recomposed image with the first three components
%     is performed
%
% Hugh Pasika 1997

P    = gha_chopstak(Orig,8,8);
mval = max(max(P));
P    = P/mval;

r = 32;  c = 32;  xdir = 8; ydir = 8;
I = zeros(r*xdir,c*ydir);
[rP cP] = size(P);      [rW, cW] = size(W);
coeffs  = zeros(rP,cW);
 
% first get the coeffs
for i=1:rP;  in=P(i,:)';   X=in(:,ones(1,cW));   coeffs(i,:)=sum(X.*W); end
 
PCAed=gha_recompose(coeffs,W,1);

if nargin == 3,
  set(gcf,'Position',[18   245   592   556])
  subplot(2,2,1); pim(Orig);     title('Original Image')
  subplot(2,2,2); gha_dispwe(W,200); title('Weights')
  subplot(2,2,3); pim(PCAed*256);    title('Using First 8 Components')
  colormap(gray)
end
