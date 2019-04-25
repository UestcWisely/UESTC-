clear
clc
%训练集
%该代码要在MATLAB16及之后的版本运行
load digitTrainSet;
%训练样本是手写数字，图片大小28*28*1（灰度图像）
%输出是标号（0-9)
%画图显示训练集
ii=[3,1,16,5,41,8,17,18,20,21];
for i=1:length(ii)
    subplot(5,2,i)
    imshow(XTrain(:,:,:,ii(i)));
end
suptitle('训练集')

%设置模型结构
layers = [imageInputLayer([28 28 1],'Normalization','none');%输入28*28*1的灰度图片。对输入进行标准化。
    convolution2dLayer(5,20);%卷积层
    reluLayer();%激活函数
    maxPooling2dLayer(2,'Stride',2);%池化层（降维）
    convolution2dLayer(5,16);
    reluLayer();
    maxPooling2dLayer(2,'Stride',2);
    fullyConnectedLayer(256);
    reluLayer();
    fullyConnectedLayer(10);
    softmaxLayer();
    classificationLayer()];
opts = trainingOptions('sgdm');%选择优化方法 Stochastic gradient descent with momentum
net = trainNetwork(XTrain,TTrain,layers,opts);%训练模型
load digitTestSet;%读取测试集
YTest = classify(net,XTest);
accuracy = sum(YTest == TTest)/numel(TTest)%分类正确率
     