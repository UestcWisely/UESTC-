% This script runs the som_2d algorithm through the ordering and 
% convergence phases.
%
% Hugh Pasika 1997

clf
P=rand(500,2);
subplot(2,2,1)
plot(P(:,1),P(:,2),'.')
title('Input Distribution')
drawnow

subplot(2,2,2)
W=(rand(10,10,2)*.2)-.1;
som_pl_map(W,1,2)
title('Initial Weights')
set(gca,'Box','On')
drawnow

subplot(2,2,3)
[W1 p1]=som_2d(P,10,10,10,[.01,8],W);
som_pl_map(W1,1,2)
title('Ordering Phase')
set(gca,'Box','On')
drawnow

subplot(2,2,4)
W=som_2d(P,10,10,200,[p1(1) .001 p1(2) 0],W1);
som_pl_map(W,1,2)
title('Convergence Phase')
set(gca,'Box','On')
drawnow
