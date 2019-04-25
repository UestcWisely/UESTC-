function [W_out, p_out]=som_1d(P, nsofm, epochs, phas, W)

% function W=som_1d(P, nsofm, lri, epochs, W)
%
%    P      - patterns
%    nsofm  - number of neurons
%    epochs - number of epochs to train for
%    phas   - either
%	      two element vector for initialization phase
%		[initial_learning_rate initial_neighbourhood_size]
%		these values will decrease exponentially during training
%	      four element vector for convergence phase
%		[initial_learning_rate         final_learning_rate ...
%		 initial_neighbourhood_size    final_neighbourhood_size]
%		these values will decrease linearly during training
%    W      - initial weight values (optional)
%
%    W_out  - final weights
%    p_out  - parameters at the end of training (learning rate, neighbourhood size)
%
% Hugh Pasika   1997

if nargin == 4, W=randn(nsofm,2)*.1; end
mx=min(P(:,1));mxx=max(P(:,1));
my=min(P(:,2));myx=max(P(:,2));

n  = 1:epochs;

if length(phas) == 2,
  so = phas(2);
  t1 = epochs./(log(so+1));
  sigmas = so*exp(-n/t1);
  lrs    = phas(1)*exp(-n/epochs);
else
  sigmas = (phas(3)-phas(4))*fliplr(n)/epochs+phas(4);
  lrs    = (phas(1)-phas(2))*fliplr(n)/epochs+phas(2);
end

[tpr tpc]=size(P);

ax=(max(abs([max(P) min(P)]))); % outer boundary for graphing

for epoch=1:epochs
  Ps=shuffle(P);
  sigma=sigmas(epoch); 
  lr = lrs(epoch);
  disp([epoch lr sigma])
    for i=1:tpr,			% train for one epoch

      %%%%%%%%%%%  determine winner
      t=Ps(i,:);  Dup = t(ones(nsofm,1),:);
      [toss, winner] = min(sum((Dup-W)'.^2));
      mask = [-(winner-1):1:nsofm-winner];
      m    = (1/(2*pi*sigma^2)*exp((-mask.^2/(2*sigma^2))));
      m    = m/max(m);
      m    = [m' m'];
      W    = W + lr*m.*(Dup - W);

    end
  figure(1)
  clf

  plot(W(:,1),W(:,2))
  axis([mx mxx my myx])  
  drawnow

  W_out = W;
  p_out = [lr(length(lr)) sigmas(length(sigmas))];

end

