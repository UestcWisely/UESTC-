function y=proymenor(x,threshold,relax)
%
% Relaxed projection onto x<=threshold : P+relax(I-P)=(1-relax)P+relaxI
%

% AAR, 1/8/97

y=x.*(x<=threshold)+threshold*ones(size(x)).*(x>threshold);
y=(1-relax)*y+relax*x;