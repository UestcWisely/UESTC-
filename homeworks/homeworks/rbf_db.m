function rbf_db(w, t, sigma, st_sz)

% w     - weights
% t     - centers
% sigma - center spread
% st_sz - step size to be used in grid for decision boundary
%

% plot decision boundary for the two class problem

x=-4:st_sz:4;   y=-3:st_sz:3;
c=0; Z=[];
for i=1:length(x),
  for j=1:length(y),
   c=c+1;
   Z(c,1:2)=[x(i) y(j)];
  end
end

gridout = rbf_test(w,Z,t,sigma);
Y = logical(gridout(:,2) > gridout(:,1));
H = reshape(Y,length(y),length(x));
contour(x,y,H,1)
grid
pl_circ([-2/3 0], 2.34, .01, 0);
title('Decision Boundary')
