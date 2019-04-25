clear
clc
%该例子用的是早发精分患者的AAL90(4005条边)模板的全脑功能连接。
%PS：这个例子中的数据可以换成任何数据（数据的格式换成人数*特征即可，但是特征维度很高的特征要先进行特征降维，防止过拟合）
M=[60,20,4];%三层（隐含层）自编码模型的的中间层的神经元个数。
%里面的参数和神经网络一致。在后面的模型中可以调整。

%总共63个人，病人和正常人分别是 30和31
%数据大小63*4005；

%里面的参数和神经网络一致，具体含义参见code1和nnsetup的解释。在后面的模型中可以调整。

load('fcdata')
l=zeros(size(data,1),2);
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

%十折交叉验证
predicted=[];
ac=[];

N=2;%十折交叉验证的次数
m=10;%每一次模型训练的次数
for i=1:N
    i
    [train,test] = crossvalind('LeaveMOut',size(data,1),5);
    
    sae = saesetup([size(data,2) M]);
    sae.ae{1}.activation_function       = 'sigm';%激活函数
    sae.ae{1}.learningRate              = 0.5;%学习率。
    
    sae.ae{2}.activation_function       = 'sigm';
    sae.ae{2}.learningRate              = 0.5;
    
    sae.ae{3}.activation_function       = 'sigm';
    sae.ae{3}.learningRate              = 0.5;
    
    opts.numepochs = m;
    opts.batchsize = 1;
    sae = saetrain(sae, data(train,:), opts);
    
    
    % Use the SDAE to initialize a FFNN
    nn = nnsetup([size(data,2) M 2]);
    nn.activation_function              = 'sigm';
    nn.learningRate                     = 0.5;
    
    %add pretrained weights
    nn.W{1} = sae.ae{1}.W{1};
    nn.W{2} = sae.ae{2}.W{1};
    nn.W{3} = sae.ae{3}.W{1};
    
    % Train the FFNN
    opts.numepochs = m;
    opts.batchsize = 1;
    nn = nntrain(nn, data(train,:), l(train,:), opts);
    predicted=[predicted;nnpredict(nn, data(test,:))];
    ac=[ac;labels(test)];
end
length(find(predicted==ac))/length(ac)%分类正确率