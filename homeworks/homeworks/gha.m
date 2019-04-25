function W=gha(P,epochs,m,beta,W)

% function W=gha(P,epochs,m,beta,W)
%
%  this routine runs the GHA 
%
%   P      = pattern vectors
%   epochs = number of epochs to train with
%   m      = number of components
%   beta   = step size try (.0001)
%   W      = optional initial weight vector
%
% Hugh Pasika 1997

[rP cP]=size(P);	
if nargin < 7, W=rand(m,cP)*(max(max(P))); end

for epoch=1:epochs,
   cc=clock;
   ind=rand(1,rP); [y inds]=sort(ind); P=P(inds,:);

   for j=1:rP,
      x       = P(j,:); 
      Wd      = zeros(size(W));
      y(1)    = dot(W(1,:),x);
      Wd(1,:) = beta*y(1)*(x-y(1)*W(1,:));
      for h=2:m,
	 y(h) = dot(W(h,:),x);
	 temp = 0; for k=1:h, temp=temp+W(k,:)*y(k); end
	 Wd(h,:)=beta*y(h)*(x-temp);    
      end
      W=W+Wd;
   end

   fprintf(1,'Just trained epoch %g of %g. It took %g seconds.\n',epoch,epochs,etime(clock,cc))
end

W=W';
