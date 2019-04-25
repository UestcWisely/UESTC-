function W=hop_stor(P)

% function W=hop_stor(P)
%
%  performs the storage (learning phase) for a Hopfield network 
%
%   W - weight matrix
%   P - patterns to be stored (column wise matrix)
%
% Hugh Pasika 1997

[n p]=size(P);      W=zeros(n,n);
for j=2:n,  
    for i=1:j-1,
        W(i,j)=dot(P(i,:),P(j,:))/n;
        W(j,i)=W(i,j);
    end
end


