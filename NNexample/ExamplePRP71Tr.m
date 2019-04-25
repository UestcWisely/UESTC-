% ExamplePRP71Tr
clear all;

pr=[0 1;0 1];
net=newp(pr,1);
%net.layers{1}.transferFcn='hardlims';

p=[0.2 0.7;0.3 0.3;0.4 0.5;0.1 0.4;0.6 0.2;0.7 0.4;0.8 0.6;0.7 0.5]';
t=[0 0 0 0 1 1 1 1];
[net,tr]=train(net,p,t);

save netPRP71 net