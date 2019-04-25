% Example32Sim
clear all;
load net32 net
ptest1=[1 1 1 1 0 1 1 0 1 1 0 1 1 0 1;
       1 1 0 0 1 0 0 1 1 0 1 0 1 1 1];
ptest=ptest1';   
a=sim(net,ptest)
