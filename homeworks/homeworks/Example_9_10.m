% Example_9_10
function [NN_w1 NN_w NN_w1_1 NN_w_1]=Som_912()
clf
%--设置符号代码的值
a=0.2;
%--训练数据集
P=[a 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ,
   0 a 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ,
   0 0 a 0 0 0 0 0 0 0 0 0 0 0 0 0 ,
   0 0 0 a 0 0 0 0 0 0 0 0 0 0 0 0 ,
   0 0 0 0 a 0 0 0 0 0 0 0 0 0 0 0 ,
   0 0 0 0 0 a 0 0 0 0 0 0 0 0 0 0 ,
   0 0 0 0 0 0 a 0 0 0 0 0 0 0 0 0 ,
   0 0 0 0 0 0 0 a 0 0 0 0 0 0 0 0 ,
   0 0 0 0 0 0 0 0 a 0 0 0 0 0 0 0 ,
   0 0 0 0 0 0 0 0 0 a 0 0 0 0 0 0 ,
   0 0 0 0 0 0 0 0 0 0 a 0 0 0 0 0 ,
   0 0 0 0 0 0 0 0 0 0 0 a 0 0 0 0 ,
   0 0 0 0 0 0 0 0 0 0 0 0 a 0 0 0 ,
   0 0 0 0 0 0 0 0 0 0 0 0 0 a 0 0 ,
   0 0 0 0 0 0 0 0 0 0 0 0 0 0 a 0 ,
   0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 a ,
   1 1 1 1 1 1 0 0 0 0 1 0 0 0 0 0 ,
   0 0 0 0 0 0 0 1 1 1 1 0 0 0 0 0 ,
   0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 ,
   1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 ,
   0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 ,
   0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 ,
   0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 ,
   0 0 0 0 0 0 0 0 0 1 0 0 1 1 1 0 ,
   1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 ,
   0 0 0 0 1 1 1 1 0 1 1 1 1 0 0 0 ,
   0 0 0 0 0 0 0 0 1 1 0 1 1 1 1 0 ,
   1 0 0 1 1 1 1 0 0 0 0 0 0 0 0 0 ,
   0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0]';
%--排序阶段权值
[W1 p1]=som_2d(P,10,10,2000,[.01,8]);
figure(1);
subplot(2,1,1);
som_pl_map(W1,1,2)
title('Ordering weights')
%--收敛阶段权值
W=som_2d(P,10,10,5000,[p1(1) 0.001 p1(2) 0],W1);
subplot(2,1,2);
som_pl_map(W,1,2)
title('Convergence weights')
%--测试数据集
T=[a 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ,
   0 a 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ,
   0 0 a 0 0 0 0 0 0 0 0 0 0 0 0 0 ,
   0 0 0 a 0 0 0 0 0 0 0 0 0 0 0 0 ,
   0 0 0 0 a 0 0 0 0 0 0 0 0 0 0 0 ,
   0 0 0 0 0 a 0 0 0 0 0 0 0 0 0 0 ,
   0 0 0 0 0 0 a 0 0 0 0 0 0 0 0 0 ,
   0 0 0 0 0 0 0 a 0 0 0 0 0 0 0 0 ,
   0 0 0 0 0 0 0 0 a 0 0 0 0 0 0 0 ,
   0 0 0 0 0 0 0 0 0 a 0 0 0 0 0 0 ,
   0 0 0 0 0 0 0 0 0 0 a 0 0 0 0 0 ,
   0 0 0 0 0 0 0 0 0 0 0 a 0 0 0 0 ,
   0 0 0 0 0 0 0 0 0 0 0 0 a 0 0 0 ,
   0 0 0 0 0 0 0 0 0 0 0 0 0 a 0 0 ,
   0 0 0 0 0 0 0 0 0 0 0 0 0 0 a 0 ,
   0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 a ,
   0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ,
   0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ,
   0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ,
   0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ,
   0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ,
   0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ,
   0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ,
   0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ,
   0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ,
   0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ,
   0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ,
   0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ,
   0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]';
%==============包含具有最强响应的标定神经元的特征映射=============
NN_w1=zeros(10,10);
NN_w=zeros(10,10);
%---计算
for h=1:16
    M_w1=0;
    M_w=0;
for i=1:10
    for j=1:10
         M1=0;
         M2=0;
           for k=1:29
               M1=M1+W(i,j,k)*T(h,k);
               M2=M2+W1(i,j,k)*T(h,k);
            end;
            if M_w<M1
                POS_wi=i;
                POS_wj=j;
                M_w=M1;
            end;    
            if M_w1<M2
                POS_w1i=i;
                POS_w1j=j;
                M_w1=M2;
            end;    
        end;
    end;
    NN_w1(POS_w1i,POS_w1j)=h;
   NN_w(POS_wi,POS_wj)=h;
end;
NN_w1
NN_w
%--文字显示
figure(2);
text_plot(NN_w1);
title('ordering phase');
figure(3);
text_plot(NN_w);
title('Convergence  phase')
%=======利用“模拟电极渗透映射”的语义映射＝＝＝＝＝＝＝＝＝＝＝
NN_w1_1=zeros(10,10);
NN_w_1=zeros(10,10);
%----计算
for i=1:10
    for j=1:10
         M_w1=0;
         M_w=0;
         for h=1:16
            M1=0;
            M2=0;
            for k=1:29
               M1=M1+W(i,j,k)*T(h,k);
               M2=M2+W1(i,j,k)*T(h,k);
            end;
            if M_w<M1
               NN_w_1(i,j)=h;
                M_w=M1;
            end;    
            if M_w1<M2
                NN_w1_1(i,j)=h;
                M_w1=M2;
            end;    
        end;
    end;
end;
NN_w1_1
NN_w_1
%---文字显示
figure(4);
text_plot(NN_w1_1);
title('ordering phase');
figure(5);
text_plot(NN_w_1);
title('Convergence  phase');
function text_plot(z);
[cz rz]=size(z);
s=cell(cz,rz);
for i=1:cz
    for j=1:rz
        switch z(i,j)
            case 0
                s(i,j)={'          '};
            case 1
                s(i,j)={'   dove   '};
            case 2
                s(i,j)={'   hen    '};
            case 3
                s(i,j)={'   duck   '};
            case 4
                s(i,j)={'   goose  '};
            case 5
                s(i,j)={'   owl    '};
            case 6
                s(i,j)={'   hawk   '};
            case 7
                s(i,j)={'   eagle  '};
            case 8
                s(i,j)={'   fox    '};
            case 9
                s(i,j)={'   dog    '};
            case 10
                s(i,j)={'   wolf   '};
            case 11
                s(i,j)={'   cat    '};
            case 12
                s(i,j)={'   tiger  '};
            case 13
                s(i,j)={'   lion   '};
            case 14
                s(i,j)={'   horse  '};
            case 15
                s(i,j)={'   zebra  '};
            case 16
                s(i,j)={'   cow    '};
        end;
   end;
end;
cellplot(s);
        
               
                