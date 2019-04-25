function K=gha_dispwe(W,j)

% function K=gha_dispwe(W,j)
%
%  - displays 8 * 64 matrix as 8 blocks in a 4 by 2 image
%  - used for visualizing principal components resulting from GHA
%  - if nargin > 1, the weights are scaled to fit the range 0 -> j
%
% Hugh Pasika 1997


if nargin > 1, W=W-(min(min(W))); W=W/max(max(W))*j; end

K=zeros(32,16);

for k=1:4,
   for j=1:2,
      K((k-1)*8+1:k*8,(j-1)*8+1:j*8)=reshape(W(:,(k-1)*2+j),8,8);
   end
end

pim(K)

