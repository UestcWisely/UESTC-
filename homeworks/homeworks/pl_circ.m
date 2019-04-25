function out=pl_circ(cen, radius, res, plot_flag)

%  function out=pl_circ(cen, radius, res, plot_flag)
%
%  returns a two column matrix (out) that when plotted (column vs..
%  column will produce a circle
%
%  cen	     - two element vector giving circle's center
%  radius    - radius of circle
%  res	     - resolution of grid circle if plotted on
%  plot_flag - any value here will plot the circle
%  out	     - x,y pairs  that form the circle
%
%  this line will plot the optimum decision boundary for the
%  two class problem
%  c=pl_cir([-2/3 0], 2.34, .01, 1);
%
% Hugh Pasika 1997 

x=-1:res:1;  y=sqrt(1-x.^2);
x=x*radius+cen(1);   y=y*radius;
y1=y+cen(2);         y2=-y+cen(2);

out=[x',y1';fliplr(x)',y2'];

if nargin  == 4,
  hold on
  plot(out(:,1),out(:,2))
  hold off
end




