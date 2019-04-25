function [o1,o2,o3,o4,o5] = shuffle(n1,n2,n3,n4,n5)

%  function [o1,o2,o3,o4,o5] = shuffle(n1,n2,n3,n4,n5)
%
%   shuffles rows of matrices maintaining same order between them
%   



[r c]=size(n1);
[y,idx] = sort(rand(1,r));

for i=1:nargin;
  eval(['o' num2str(i) '=n' num2str(i) '(idx,:);']);
end





