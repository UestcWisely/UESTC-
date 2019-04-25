% Example_9_6
clear all;
som_2d_demo;
P=rand(1000,2);
figure;
plot(P(:,1),P(:,2));
figure;
[W1s p1]=som_1d(P,200,10, [.1 18]);
figure;
[W2s p2]=som_1d(P,200,50, [p1(1) .001 p1(2) 0],W1s);
