function c=bsb(x,beta,multi)

% function c=bsb(x,beta)
%
%  This m-file duplicates the Brain State in a Box Experiment.
%    x     - input vector
%    beta  - feedback factor 
%    c     - number of iterations required for convergence
%    
% Hugh Pasika 1997

hold on
flag=0;   x=x(:);   c=2; %c is a general purpose counter
W=[.035 -.005; -.005 .035];

%corners=[1 1;1 -1; -1 -1; -1 1];
%plot(corners(:,1),corners(:,2),'.w')

set(gca,'YLim',[-1 1]);      set(gca,'XLim',[-1 1])	% set axes

plot(x(1),x(2),'ob')	     % plot first point	
orig=x';
plot([0,0],[1,-1],'-');      plot([1,-1],[0,0],'-')     % plot center lines
set(gca,'YTick',[-1  1 ]);   set(gca,'XTick',[-1  1 ])  % label plot

while flag < 1,
y=x+beta*W*x;
x=(y(:,:) < -1 )*(-1) + (y(:,:)>1) + (y(:,:) > -1 & y(:,:) < 1).*y;
u(c,:)=x';
c=c+1;
 if u(c-1,:) == u(c-2,:),
   flag=10;
   c=c-3;
 end
end

u=u(2:c+1,:);

orig
plot([orig(1,1) u(1,1)], [orig(1,2) u(1,2)],'-b')
plot(u(:,1), u(:,2),'ob')
plot(u(:,1), u(:,2),'-b')

drawnow

fprintf(1,'It took %g iteration for a stable point to be reached.\n\n',c);
set(gca,'Box','on')

hold off




