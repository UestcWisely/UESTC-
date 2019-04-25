function A=bpm_dec_bnds(W1, b1, W2, b2, st_sz)

% function A=bpm_dec_bnds(W1, b1, W2, b2, st_sz)
%
% Determines the decision boundaries using the weights calculated by
% the bpm_train routine.
% The region of interest is hard coded (x=-6:st_sz:6; y=-4:st_sz:4;).
% st_sz is the resolution of the grid over which testing is performed.
%
% Hugh Pasika 1997

x=-6:st_sz:6;	y=-4:st_sz:4;

for i=1:length(x),
  for j=1:length(y),
    input  = [x(i) y(j)]';
    outHiddenLayer = bpm_phi(W1*input+b1);
    outOutputLayer = bpm_phi(W2*outHiddenLayer+b2);
    output	  = outOutputLayer;
    if output(1) > output(2)
      A(j,i)=-1;
    else
      A(j,i)=1;
    end
  end
end

contour(x,y,A,1);
set(gca,'XLim',[-6 6]);
grid

title('Decision Boundary')
