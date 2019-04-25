function [mainpca,evals]=pca(data)
%data 是  m*n 维数据，m表示每一个（道）信号的采样点，m表示m个（道）信号. 
%mainpca 是主特征向量。mainpca is main characteric value
%计算协方差
Maxtrix=data'*data;
%计算特征分解
[u,d,v]=svd(Maxtrix);
%计算特征值对角线元素
evals=real(diag(d));
%原数据向特征向量的投影，得到主成分
subplot(221)
plot(data)

mainpca=data*u(:,1);
subplot(222)
plot(mainpca);
%投影到原始数据
subplot(223)
plot(mean(data'));

datanew=data*(u(:,1:5)*u(:,1:5)');
subplot(224)
plot(datanew);
return
