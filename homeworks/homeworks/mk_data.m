function C=mak_data(pats)

% function C=mk_data(pats)
%
%  makes the data used in the backprop, RBF, SVM experiment
%  
%  pats - number of pattern vectors to create - must be even as
%         the two classes are equiprobable
%
%  column 1 - x coordinate
%  column 2 - y coordinate
%  column 3 - target 1
%  column 4 - target 2
%  column 5 - class
%
% Hugh Pasika 1997


if floor(pats/2)*2 ~= pats,
    disp('Number of patterns should be equal - try again!'); 
    return
end

f=pats/2;

C1=randn(f,2);
C1(:,3)=ones(f,1)*.95;
C1(:,4)=ones(f,1)*.05;
C1(:,5)=zeros(f,1);

C2=randn(f,2);
C2=C2*2;
C2(:,1)=C2(:,1)+2;
C2(:,3)=ones(f,1)*.05;
C2(:,4)=ones(f,1)*.95;
C2(:,5)=ones(f,1)*1;

% shuffle them up
H=[C1' C2']';
[y i]=sort(rand(f*2,1));
C=H(i,:);


