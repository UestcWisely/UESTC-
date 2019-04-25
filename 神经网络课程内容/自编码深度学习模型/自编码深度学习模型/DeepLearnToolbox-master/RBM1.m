clear
clc
%该例子用的是早发精分患者的AAL90(4005条边)模板的全脑功能连接。
%PS：这个例子中的数据可以换成任何数据（数据的格式换成人数*特征即可）
M=[100,100];%RBM的层数
Nout=2;%神经网络的输出层数，这里用的是二分类所以填成2就可以。
%说明：该例子和SAE一样，先用DBN降维，然后用DBN（就是几层神经网络，但是权重更新方式不一样）的网络去初始化神经网络
%这么做就可以让后来层数比较深的网络，减少训练的负担。
load('fcdata')
%构建分类标签
for i=1:30
    l(i,1)=1;
end
for i=31:63
    l(i,2)=1;
end
labels=ones(63,1);
for i=31:63
    labels(i)=2;
end
%丢掉负值，因为模型要求所有的特征必须是0-1范围内的，这里这么做是为了演示，处理实际问题要采取合理的办法
data(find(data<0))=0;

%交叉验证
predicted=[];
ac=[];
N=2;%十折交叉验证的次数
m=1;%每一次模型训练的次数
for i=1:N
    i
    [train,test] = crossvalind('LeaveMOut',size(data,1),5);

    
    %train dbn
    dbn.sizes =M;
    
    %下面这两个和SAE的模型训练方法一样，都是为了提高模型稳定性，磁共振数据量少，可以不用修改。
    opts.numepochs =  m;
    opts.batchsize = 1;
    
    opts.momentum  =   0;%优化算法参数，可以不用管
    opts.alpha     =   1;%学习率权重更新速度
    
    %模型声明及训练
    dbn = dbnsetup(dbn, data(train,:), opts);
    dbn = dbntrain(dbn, data(train,:), opts);
    %这部分以上可以理解为一个降维的过程，当然也可以直接让RBN的输出一维的标签【100,1】，但是效果肯定不理想。
    
    
    %unfold dbn to nn
    %把训练得到的DBN的参数赋值给NN
    nn = dbnunfoldtonn(dbn, Nout);
    nn.activation_function = 'sigm';%激活函数
    
    %train nn
    opts.numepochs =  m;
    opts.batchsize = 1;%训练优化方式，不用修改
    nn = nntrain(nn, data(train,:), l(train,:), opts);
    predicted=[predicted;nnpredict(nn, data(test,:))];
    ac=[ac;labels(test)];
end
length(find(predicted==ac))/length(ac)%分类正确率
