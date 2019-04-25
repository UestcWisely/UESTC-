function [W_out, p_out]=som_2d(P, nsofmx, nsofmy, epochs, phas, W)

% function W=som_2d(P, nsofmx, nsofmy, epochs, phas, W)
%
% uses a Gaussian neighbourhood thus size refers to the spread of the Gaussian
%
%    P      - patterns
%    nsofmx/y  - number of neurons
%    epochs - number of epochs to train for
%    phas   - either
%             two element vector for ordering phase
%               [initial_learning_rate initial_neighbourhood_size]
%               these values will decrease exponentially during training
%             four element vector for convergence phase
%               [initial_learning_rate         final_learning_rate ...
%                initial_neighbourhood_size    final_neighbourhood_size]
%               these values will decrease linearly during training
%    W      - initial weight values (optional)
%
%    W_out  - final weights
%    p_out  - final values for learning rate and neighbourhood size 
%
% Hugh Pasika   1997 

r=nsofmx;  c=nsofmy; cr=r+1; cc=c+1;
[pats dimz]=size(P);    
if nargin < 6, W=randn(nsofmx,nsofmy,dimz)*.1; end
mx=min(P(:,1));mxx=max(P(:,1));
my=min(P(:,2));myx=max(P(:,2));

n = 1:epochs;

if length(phas) == 2,
  so = phas(2);
  t1 = epochs/(log(so+1));
  sigmas = so*exp(-n/t1);
  lrs    = phas(1)*exp(-n/epochs);
else
  sigmas = (phas(3)-phas(4))*fliplr(n)/epochs+phas(4);
  lrs    = (phas(1)-phas(2))*fliplr(n)/epochs+phas(2);
end

mask=zeros(2*r+1,2*c+1);
x=[-c:c];   y=[r:-1:-r];
for i=1:length(x), for j=1:length(y),
      mask(j,i)=sqrt(x(i)^2+y(j)^2);
   end
end


  sigma=sigmas(1)
  m = (1/(2*pi*sigma^2)*exp((-mask.^2/(2*sigma^2))));
  m = m/max(max(m));
  lbr =cr-floor(r/2);
  ubr =cr+floor(r/2);
  lbc =cc-floor(r/2);
  ubc =cc+floor(r/2);

  sigma=sigmas(length(sigmas));
  m = (1/(2*pi*sigma^2)*exp((-mask.^2/(2*sigma^2))));
  m = m/max(max(m));

ax=(max(abs([max(P) min(P)]))); % outer boundary for graphing
ax=([min(P(:,1)) max(P(:,1)) min(P(:,2)) max(P(:,2)) ]);

for epoch=1:epochs,
   t=clock;
   [neword]=shuffle(P);
   sigma=sigmas(epoch);
   for pat=1:pats,

      in=neword(pat,:)';
      Dup=in(:,ones(r,1),ones(c,1));
      Dup=permute(Dup,[2,3,1]);
      Dif= W - Dup;
      Sse=sum(Dif.^2,3);
      [val1 win_rows]=min(Sse); [val2 wc]=min(val1); wr=win_rows(wc);
      WN(pat,1:2)=[wr wc];

      M1 = mask(cr-wr+1:cr+(r-wr),cc-wc+1:cc+(c-wc));     % get mask section
      M1 = (1/(2*pi*sigma^2)*exp((-M1.^2/(2*sigma^2)))); 
      M1 = M1/max(max(M1)); 				  % gaussianiffy

      M1=M1(:,:,ones(1,dimz));
      W = W + lrs(epoch)*(Dup-W).*M1;                     % multiply

   end

   secs=etime(clock,t);
   fprintf(1,'On epoch %i of %i next update approx %g seconds from now.\n\n',epoch,epochs,secs)
   t=clock;

   p_out = [lrs(length(lrs)) sigma];
   W_out = W;

%   som_pl_map(W,1,2); drawnow

end


