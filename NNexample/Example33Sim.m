% Example33Sim
clear all;
load net33 net
ptest1=[1 1 1 1 0 1 1 0 1 1 0 1 1 0 1;
       1 1 0 0 1 0 0 1 1 0 1 0 1 1 1;
       1 1 1 0 1 1 0 1 0 1 1 1 0 0 0;
       1 1 1 1 1 0 1 0 1 0 0 0 1 1 1];
ptest=ptest1';   
a=sim(net,ptest)   
       