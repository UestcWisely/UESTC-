function [pesos,vect,b]=svm_rbf2(datos,escala,niter,cad,restric);
%
% [pesos,vect,b]=svm_rbf(datos,escala,niter,cad,restric);
%
%	datos   - data
%	escala  - width of centers
%	niter   - number of iterations
%	cad     - learning rate
%	restric - regularization parameter
%
%	pesos	- weights
%	vect	- support vectors
%	b	- bias
%
% Hugh Pasika 1997

[numero,pp]=size(datos);
y = 2*datos(:,5)-1;
k = zeros(numero,numero);

for i=1:numero, 
	k(:,i)=(datos(:,1)-datos(i,1)).^2 + (datos(:,2)-datos(i,2)).^2;
end

k = exp(-k/escala);
k = k.*(y*(y'));	% no estoy seguro de esto

alfa=zeros(numero,1);

for i=1:niter
	alfa=alfa+cad*(1-k*alfa);
	alfa=alfa-mean(alfa.*y)*y;
	alfa=svm_proymenor(svm_proymayor(alfa,0,0),restric,0);
%	plot(i,(sum(alfa)+(alfa')*k*alfa)),drawnow
end

aux1=find(alfa~=0);
if length(aux1)==0, error('No support vectors identified.'); end

pesos = alfa(aux1).*y(aux1);
vect  = datos(aux1,:);

k = k./(y*(y'));
k = k(aux1,:);
b = mean(y-(k')*pesos);
