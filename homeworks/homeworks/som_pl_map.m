function som_pl_map(A,p1,p2, P1, P2)

%  function som_pl_map(A,p1,p2)
%    
%    plot the grid formed by an SOFM
%      A      - SOFM weights
%      p1, p2 - two planes to be used for plotting
%    
% Hugh Pasika  1997

if nargin == 3, P1=A(:,:,p1);  P2=A(:,:,p2); end

[r c]=size(P1);
cla
hold on

%plot horizontal
for j=1:c-1,
   plot([P1(:,j),P1(:,j+1)],[P2(:,j),P2(:,j+1)],'-b')
end

%plot vertical
for i=1:c-1,
   plot([P1(i,:)',P1(i+1,:)'],[P2(i,:)',P2(i+1,:)'],'-b')
end
hold off
