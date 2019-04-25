% Example34Sim
clear all;
load net34 net1 net2

p1=[0 0;0 1;1 0;1 1]';
a1=sim(net1,p1);

p2=ones(3,4);
p2=p2.*a1;
a2=sim(net2,p2)