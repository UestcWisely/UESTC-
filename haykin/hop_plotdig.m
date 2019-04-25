function hop_plotdig(P,r,c,stri)

% function hop_plotdig(P,r,c)
% 
% displays the hopfield digit stored in P
% if P is a vector, it much first be reshaped
%
% Hugh Pasika 1997

if nargin > 1,  P=reshape(P,r,c);  end

P=(P+1)*64;  colormap('bone');  
image(P);

a=gca;  set(a,'XTick',[ ]);  set(a,'YTick',[ ])
if nargin == 4, xlabel(stri); end
