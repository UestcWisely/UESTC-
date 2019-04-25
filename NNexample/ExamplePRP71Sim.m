% ExamplePRP71Sim
clear all;
load netPRP71 net

p=[0.2 0.7;0.3 0.3;0.4 0.5;0.1 0.4;0.6 0.2;0.7 0.4;0.8 0.6;0.7 0.5]';
a=sim(net,p)

v=[0 1 0 1];
plotpv(p,a,v);
plotpc(net.iw{1},net.b{1});