clear
clc
%�������õ����緢���ֻ��ߵ�AAL90(4005����)ģ���ȫ�Թ������ӡ�
%PS����������е����ݿ��Ի����κ����ݣ����ݵĸ�ʽ��������*�������ɣ�
M=[100,100];%RBM�Ĳ���
Nout=2;%���������������������õ��Ƕ������������2�Ϳ��ԡ�
%˵���������Ӻ�SAEһ��������DBN��ά��Ȼ����DBN�����Ǽ��������磬����Ȩ�ظ��·�ʽ��һ����������ȥ��ʼ��������
%��ô���Ϳ����ú��������Ƚ�������磬����ѵ���ĸ�����
load('fcdata')
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
%������ֵ����Ϊģ��Ҫ�����е�����������0-1��Χ�ڵģ�������ô����Ϊ����ʾ������ʵ������Ҫ��ȡ����İ취
data(find(data<0))=0;

%������֤
predicted=[];
ac=[];
N=2;%ʮ�۽�����֤�Ĵ���
m=1;%ÿһ��ģ��ѵ���Ĵ���
for i=1:N
    i
    [train,test] = crossvalind('LeaveMOut',size(data,1),5);

    
    %train dbn
    dbn.sizes =M;
    
    %������������SAE��ģ��ѵ������һ��������Ϊ�����ģ���ȶ��ԣ��Ź����������٣����Բ����޸ġ�
    opts.numepochs =  m;
    opts.batchsize = 1;
    
    opts.momentum  =   0;%�Ż��㷨���������Բ��ù�
    opts.alpha     =   1;%ѧϰ��Ȩ�ظ����ٶ�
    
    %ģ��������ѵ��
    dbn = dbnsetup(dbn, data(train,:), opts);
    dbn = dbntrain(dbn, data(train,:), opts);
    %�ⲿ�����Ͽ������Ϊһ����ά�Ĺ��̣���ȻҲ����ֱ����RBN�����һά�ı�ǩ��100,1��������Ч���϶������롣
    
    
    %unfold dbn to nn
    %��ѵ���õ���DBN�Ĳ�����ֵ��NN
    nn = dbnunfoldtonn(dbn, Nout);
    nn.activation_function = 'sigm';%�����
    
    %train nn
    opts.numepochs =  m;
    opts.batchsize = 1;%ѵ���Ż���ʽ�������޸�
    nn = nntrain(nn, data(train,:), l(train,:), opts);
    predicted=[predicted;nnpredict(nn, data(test,:))];
    ac=[ac;labels(test)];
end
length(find(predicted==ac))/length(ac)%������ȷ��
