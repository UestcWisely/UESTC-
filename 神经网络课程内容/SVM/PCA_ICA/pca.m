function [mainpca,evals]=pca(data)
%data ��  m*n ά���ݣ�m��ʾÿһ���������źŵĲ����㣬m��ʾm���������ź�. 
%mainpca ��������������mainpca is main characteric value
%����Э����
Maxtrix=data'*data;
%���������ֽ�
[u,d,v]=svd(Maxtrix);
%��������ֵ�Խ���Ԫ��
evals=real(diag(d));
%ԭ����������������ͶӰ���õ����ɷ�
subplot(221)
plot(data)

mainpca=data*u(:,1);
subplot(222)
plot(mainpca);
%ͶӰ��ԭʼ����
subplot(223)
plot(mean(data'));

datanew=data*(u(:,1:5)*u(:,1:5)');
subplot(224)
plot(datanew);
return
