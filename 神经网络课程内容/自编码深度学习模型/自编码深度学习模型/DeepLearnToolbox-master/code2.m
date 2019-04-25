clear
clc
%�������õ����緢���ֻ��ߵ�AAL90(4005����)ģ���ȫ�Թ������ӡ�
%PS����������е����ݿ��Ի����κ����ݣ����ݵĸ�ʽ��������*�������ɣ���������ά�Ⱥܸߵ�����Ҫ�Ƚ���������ά����ֹ����ϣ�
M=[60,20,4];%���㣨�����㣩�Ա���ģ�͵ĵ��м�����Ԫ������
%����Ĳ�����������һ�¡��ں����ģ���п��Ե�����

%�ܹ�63���ˣ����˺������˷ֱ��� 30��31
%���ݴ�С63*4005��

%����Ĳ�����������һ�£����庬��μ�code1��nnsetup�Ľ��͡��ں����ģ���п��Ե�����

load('fcdata')
l=zeros(size(data,1),2);
%���������ǩ
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

%ʮ�۽�����֤
predicted=[];
ac=[];

N=2;%ʮ�۽�����֤�Ĵ���
m=10;%ÿһ��ģ��ѵ���Ĵ���
for i=1:N
    i
    [train,test] = crossvalind('LeaveMOut',size(data,1),5);
    
    sae = saesetup([size(data,2) M]);
    sae.ae{1}.activation_function       = 'sigm';%�����
    sae.ae{1}.learningRate              = 0.5;%ѧϰ�ʡ�
    
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
length(find(predicted==ac))/length(ac)%������ȷ��