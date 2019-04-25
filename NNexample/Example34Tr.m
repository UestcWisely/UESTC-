% Example34Tr
clear all;

pr1=[0 1;0 1];
net1=newp(pr1,3);
net1.inputweights{1}.initFcn='rands';
net1.biases{1}.initFcn='rands';
net1=init(net1);
iw1=net1.IW{1}
b1=net1.b{1}

p1=[0 0; 0 1; 1 0; 1 1]';
[a1,pf]=sim(net1,p1);

pr2=[0 1;0 1;0 1];
net2=newp(pr2,1);

net2.trainParam.epochs=10;
net2.trainParam.show=1;
p2=ones(3,4);
p2=p2.*a1;
t2=[0 1 1 0];
[net2,tr2]=train(net2,p2,t2);
epoch2=tr2.epoch
perf2=tr2.perf
iw2=net2.IW{1}
b2=net2.b{1}

save net34 net1 net2
