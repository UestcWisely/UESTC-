function [c, u, yup, nope] = svm_test(data, pesos, vect, b, escala)

% [c u] = svm_test(data, pesos, vect, b, escala)
%
%	data	- data to be tested
%       pesos   - weights
%       vect    - support vectors
%       b       - bias
%       escala  - width of centers (8, 16, 4)
%
%	c	- % correct classifications
%	u	- % uncorrect classifications
%	yup	- indices of correctly classified patterns
%	nope	- indices of incorrectly classified patterns
%
% Hugh Pasika 1997

[r, c]=size(data);

z=zeros(size(data(:,1)));

for i=1:length(pesos)
	z=z+pesos(i)*exp(-((data(:,1)-vect(i,1)).^2+(data(:,2)-vect(i,2)).^2)/escala);
end
z = z+b; 
z = sign(z);

V=[data z];

% classification accuracy
  c1   = find(V(:,5) == V(:,6));
  c2   = find(V(:,5) == 0 & V(:,6) == -1);
  yup  = [c1' c2']'; c=length(yup);

  u1   = find(V(:,5) == 1 & V(:,6) == -1);
  u2   = find(V(:,5) == 0 & V(:,6) == 1);
  nope = [u1' u2']'; u=length(nope);

nope = [u1 zeros(size(u1)); u2 ones(size(u2))];

fprintf(1,'Percent correct:    %5.2f\n', 100*c/r)
fprintf(1,'Percent incorrect:  %5.2f\n', 100*u/r)
