% Example_5_14
clear all;
n=input('请输入测试的次数 n=');
lr=input('请输入正则化参数 lr=');
cs=input('请输入隐藏层中心大小 cs=')
for i=1:n
    P=mk_data(200);
    w = rbf(P(1:100,1:2), P(:,1:2), P(1:100,3:4), cs, lr);
    T=mk_data(500);
    rbfout=rbf_test(w,T(:,1:2),P(:,1:2),cs);
    rbfcor(i,:) =rbf_correct(rbfout,T(:,5));
    figure(i);
    rbf_db(w,P(:,1:2),cs,0.2);
end
avecorrect=mean(rbfcor)
mincorrect=min(rbfcor)
maxcorrect=max(rbfcor)
stdcorrect=std(rbfcor)
