function pim(Z)

% function pim(Z)
%
% simply Plots an IMage and removes the tick marks and axis labelling
%
% Hugh Pasika 1998

image(Z);
set(gca,'XTickLabel','');
set(gca,'YTickLabel','');
set(gca,'XTick',[]);
set(gca,'YTick',[]);
