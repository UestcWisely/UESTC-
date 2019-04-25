function [hAxis,hLines] = svmplotdata(x,group,theAxis)
% SVMPLOTDATA plots 2-D data in SVM functions

% Copyright 2004 The MathWorks, Inc.

if nargin == 2
    class1 = 'r+';
    class2 = 'g*';
else
    axes(theAxis);
    hold on;
    class1 = 'm+';
    class2 = 'c*';
end
Xp = x(group==1,:);
h1 = plot(Xp(:,1),Xp(:,2),class1);
hAxis = get(h1,'parent');
hold on
Xn =  x(group==-1,:);
h2 = plot(Xn(:,1),Xn(:,2),class2);
if isempty(hAxis)
    h1 =0;
    hAxis = get(h2,'parent');
end
if isempty(h2)
    h2 = 0;
end
%axis equal
drawnow
hold off
hLines = [h1,h2];