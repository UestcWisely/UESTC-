function [I, st, xla] = gha_quantcoeffs(C,W,O,n)

% function [I, st, xla] = gha_quantcoeffs(C,W,O,n)
%
%  C - coeffs from get_coeffs
%  W - weights to be used in reconstruction
%  O - original image
%  n - bit levels for quantization
%
%  I   - recomposed image using quantized coefficients
%  st  - string yeilding mse and compression ratio 
%  xla - n in string format
%
% Side Note:
% values k are determined completely heuristically
% need someway of doing it automagically
%
% thought something like this might work
% k=(1./var(C)).*[4 2 2 2 2 2 2 2];
%
% Hugh Pasika 1997

v=std(C).^2;
b=2.^n;  bpp=sum(n)/(8*8);
k=sqrt(b./v); 

% just multiplies each column by the corresponding value in k
M=colmult(C,k);

% quantize
Q=round(M);

% set upper and lower limits for thresholding the coefficients
toss=n-1; ul=2.^toss; ul(1)=2^n(1);
ll=-ul+1; ll(1)=1;

% threshold outliers
for i=1:8,  V(:,i)=thresh(Q(:,i),ll(i),ul(i)); end

% convert from quantized values back to coefficients
H=colmult(V,1./k);

%recompose image and display
I=gha_recompose(H,W,256);
[rO cO]=size(O);
mse=sqrt( sum( sum((O-I).^2)) /(rO*cO));

mse=sqrt(sum(sum((O-I).^2))/(256*256));
st=['mse ' num2str(mse) '    bpp ' num2str(bpp)]
xla=num2str(n)


