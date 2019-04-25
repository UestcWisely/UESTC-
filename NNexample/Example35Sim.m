% Example35Sim
clear all;
load net35 net

p=[0.5 -1;1 0.5;-1 0.5;-1 -1]';
a=sim(net,p)

v=[-2 2 -2 2];
plotpv(p,a,v);
plotpc(net.iw{1},net.b{1});