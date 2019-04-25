clear
clc
load mnist_uint8;
%�������õ���ʶ����д��һ�����ݿ�ͼƬ��
%x����д��ͼƬ�ĻҶ�ͼ�����(1*784)
%y��һ��1*10�ĵ�0 1�������ֱ� ����0-9
M=[100,10];%���㣨�����㣩�Ա���ģ�͵ĵ��м�����Ԫ������
%ע�⣬�Ա���ģ��������һ�㲻�������㡣��������������㡣��������������ĵ��ӡ�
%����Ĳ�����������һ�¡��ں����ģ���п��Ե�����
%����Ĳ����μ�nnsetup������Ĭ�ϲ��������ƺ�Ĭ��ֵ��

%�ı����ݵ����ͣ����ͱ��double��
train_x = double(train_x)/255;
test_x  = double(test_x)/255;
train_y = double(train_y);
test_y  = double(test_y);
M=[size(test_x,2) M];
%%  ex1 train a 100 hidden unit SDAE and use it to initialize a FFNN
%  Setup and train a stacked denoising autoencoder (SDAE)
rand('state',0)
sae = saesetup(M(1:2));
sae.ae{1}.activation_function       = 'sigm';%��Ծ����
sae.ae{1}.learningRate              = 1;%ѧϰ��
sae.ae{1}.inputZeroMaskedFraction   = 0.5;%����һ�������ƣ�ʵ��Ӧ���п�������Ϊ�㣬��Ϊʵ�ʴŹ������ݵĽ���ܶ಻���룬��������Ч�����
%��ѵ��������һЩ������Ϊ��������ģ�͵�³����
opts.numepochs =   1;
opts.batchsize = 100;%
sae = saetrain(sae, train_x, opts);

% Use the SDAE to initialize a FFNN
nn = nnsetup(M);
nn.activation_function              = 'sigm';
nn.learningRate                     = 1;
nn.W{1} = sae.ae{1}.W{1};

% Train the FFNN
opts.numepochs =   1;%���������ʵ�����Ҫѡ�ɰ���ǧ�Σ�����Ϊ����ʾ��ѡ��һ�Ρ�
opts.batchsize = 100;%ÿ�η����ѵ�������Ĵ�С
%�����õ������ѡȡbatchsize��С��������ѵ��ģ�͵Ĳ�����
%��������ѧϰ�����е�Bagging��������ô����Ŀ����Ϊ�˷�ֹѵ��������ģ�Ͷ�ĳ�������������У�����ѥ����������˼�롣
nn = nntrain(nn, train_x, train_y, opts);
[er, bad] = nntest(nn, test_x, test_y);
accuracy=1-er