clear
clc
%ѵ����
%�ô���Ҫ��MATLAB16��֮��İ汾����
load digitTrainSet;
%ѵ����������д���֣�ͼƬ��С28*28*1���Ҷ�ͼ��
%����Ǳ�ţ�0-9)
%��ͼ��ʾѵ����
ii=[3,1,16,5,41,8,17,18,20,21];
for i=1:length(ii)
    subplot(5,2,i)
    imshow(XTrain(:,:,:,ii(i)));
end
suptitle('ѵ����')

%����ģ�ͽṹ
layers = [imageInputLayer([28 28 1],'Normalization','none');%����28*28*1�ĻҶ�ͼƬ����������б�׼����
    convolution2dLayer(5,20);%�����
    reluLayer();%�����
    maxPooling2dLayer(2,'Stride',2);%�ػ��㣨��ά��
    convolution2dLayer(5,16);
    reluLayer();
    maxPooling2dLayer(2,'Stride',2);
    fullyConnectedLayer(256);
    reluLayer();
    fullyConnectedLayer(10);
    softmaxLayer();
    classificationLayer()];
opts = trainingOptions('sgdm');%ѡ���Ż����� Stochastic gradient descent with momentum
net = trainNetwork(XTrain,TTrain,layers,opts);%ѵ��ģ��
load digitTestSet;%��ȡ���Լ�
YTest = classify(net,XTest);
accuracy = sum(YTest == TTest)/numel(TTest)%������ȷ��
     