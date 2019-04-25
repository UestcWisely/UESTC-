function svm_dec_bnd(pesos, vect, b, escala)

% function svm_dec_bnd(pesos, vect, b, escala)
%
%  plots the decision boundary for the two class Gaussian problem
%  type "help svm_rbf" for variable description
%
% Hugh Pasika 1997

y =-5:0.05:5;
x = y';  x = x(:,ones(1,length(x)));
y = x';  x = x(:);  y = y(:);
 
z=zeros(size(x));
for i=1:length(pesos)
        z=z+pesos(i)*exp(-((x-vect(i,1)).^2+(y-vect(i,2)).^2)/escala);
end

z=z+b;
 
co=pl_circ([-2/3,0],2.34,.005);
zz=zeros(201,201);
zz(:)=z;
 
y =-5:0.05:5; x = y;
 
contour(x,y,flipud(zz'),[0 0], '-')
hold on
plot(co(:,1),co(:,2),'--')
hold off
grid on
set(gca,'DataAspectRatio',[.9 1 1])
legend('SVM','Bayes')
title('Support Vector Machine Decision Boundary for Two Gaussian Problem')

