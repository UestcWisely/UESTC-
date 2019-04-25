% Example35Tr
clear all;

pr=[-1 1;-1 1];
net=newp(pr,1);
%net.layers{1}.transferFcn='hardlims';

p=[0.5 -1;1 0.5;-1 0.5;-1 -1]';
t=[0 1 1 0];
[net,tr]=train(net,p,t);

save net35 net