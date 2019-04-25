function [meanac,allacfb] = SVM_fmri_test(  )
load fmri;    %  fmri 100*80
meanfb=fmri;
meanlabelfb(1:50)=1;
meanlabelfb(51:100)=0;

for i=1:300 
locc=randperm(100); %locc是放1-32的数字的矩阵，用来将1-32的整数进行随机排序
train = meanfb(locc(1:50),:);
 %在数组meanfb中选取 16个数据做训练集x
%trainlabel = meanlabelfb(locc(1:50),:); 
trainlabel = meanlabelfb(locc(1:50)); %该标签是一个数
%在数组meanlbfb中选取 16个数据训练集x对应期望结果d ( x,d)

test = meanfb(locc(51:100),:);
%在数组meanfb中选取另 16个数据做测试集y

%testlabel = meanlabelfb(locc(51:100),:);
testlabel = meanlabelfb(locc(51:100)); %该标签是一个数
%在数组meanlbfb中选取另外 16个数据测试集y对应期望结果d ( y,d)

svmStruct = svmtrain(train, trainlabel); %svmtrain 是matlab自带的语句包
%[outclass,classified,f] = svmclassify(svmStruct,test); %svmclassify也
outclass = svmclassify(svmStruct,test); %svmclassify也

%pallfb(:,i)=f;
allrealkfb{i,1}=testlabel';
allkindsfb{i,1}=outclass;
allacfb(i,1)=1-sum(abs(outclass'-testlabel))/2/50
end

meanac=mean(allacfb);  %300次随机试验的平均准确率
end
