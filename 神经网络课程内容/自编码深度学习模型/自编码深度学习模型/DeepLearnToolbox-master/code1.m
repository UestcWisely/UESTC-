clear
clc
load mnist_uint8;
%该例子用的是识别手写的一个数据库图片。
%x是手写的图片的灰度图像矩阵(1*784)
%y是一个1*10的的0 1向量，分别 代表0-9
M=[100,10];%两层（隐含层）自编码模型的的中间层的神经元个数。
%注意，自编码模型隐含层一般不超过三层。这个例子中是两层。即：两层神经网络的叠加。
%里面的参数和神经网络一致。在后面的模型中可以调整。
%更多的参数参见nnsetup函数中默认参数的名称和默认值。

%改变数据的类型，整型编程double型
train_x = double(train_x)/255;
test_x  = double(test_x)/255;
train_y = double(train_y);
test_y  = double(test_y);
M=[size(test_x,2) M];
%%  ex1 train a 100 hidden unit SDAE and use it to initialize a FFNN
%  Setup and train a stacked denoising autoencoder (SDAE)
rand('state',0)
sae = saesetup(M(1:2));
sae.ae{1}.activation_function       = 'sigm';%阶跃函数
sae.ae{1}.learningRate              = 1;%学习率
sae.ae{1}.inputZeroMaskedFraction   = 0.5;%这是一个误差控制（实际应用中可以设置为零，因为实际磁共振数据的结果很多不理想，加了噪声效果更差）
%给训练集增加一些噪声，为的是增加模型的鲁棒性
opts.numepochs =   1;
opts.batchsize = 100;%
sae = saetrain(sae, train_x, opts);

% Use the SDAE to initialize a FFNN
nn = nnsetup(M);
nn.activation_function              = 'sigm';
nn.learningRate                     = 1;
nn.W{1} = sae.ae{1}.W{1};

% Train the FFNN
opts.numepochs =   1;%仿真次数，实际情况要选成百上千次，这里为了演示就选了一次。
opts.batchsize = 100;%每次仿真的训练样本的大小
%这里用的是随机选取batchsize大小个样本来训练模型的参数，
%属于整体学习方法中的Bagging方法：这么做的目的是为了防止训练出来的模型对某部分样本更敏感，很像靴带抽样法的思想。
nn = nntrain(nn, train_x, train_y, opts);
[er, bad] = nntest(nn, test_x, test_y);
accuracy=1-er