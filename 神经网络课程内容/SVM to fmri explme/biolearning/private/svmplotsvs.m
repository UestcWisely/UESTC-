function hSV = svmplotsvs(hAxis,svm_struct)
%SVMPLOTSVS helper function for SVM plotting

% Copyright 2004 The MathWorks, Inc.

% plot the support vectors and the separating line
hold on;
sv = svm_struct.SupportVectors;
% plot support vectors
hSV = plot(sv(:,1),sv(:,2),'ko');

lims = axis(hAxis);
[X,Y] = meshgrid(linspace(lims(1),lims(2)),linspace(lims(3),lims(4)));
[dummy, Z] = svmdecision([X(:),Y(:)],svm_struct); %#ok
contour(X,Y,reshape(Z,size(X)),[0 0],'k');
hold off;