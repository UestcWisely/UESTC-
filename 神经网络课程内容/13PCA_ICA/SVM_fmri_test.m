function [meanac,allacfb] = SVM_fmri_test(  )
load fmri;    %  fmri 100*80
meanfb=fmri;
meanlabelfb(1:50)=1;
meanlabelfb(51:100)=0;

for i=1:300 
locc=randperm(100); %locc�Ƿ�1-32�����ֵľ���������1-32�����������������
train = meanfb(locc(1:50),:);
 %������meanfb��ѡȡ 16��������ѵ����x
%trainlabel = meanlabelfb(locc(1:50),:); 
trainlabel = meanlabelfb(locc(1:50)); %�ñ�ǩ��һ����
%������meanlbfb��ѡȡ 16������ѵ����x��Ӧ�������d ( x,d)

test = meanfb(locc(51:100),:);
%������meanfb��ѡȡ�� 16�����������Լ�y

%testlabel = meanlabelfb(locc(51:100),:);
testlabel = meanlabelfb(locc(51:100)); %�ñ�ǩ��һ����
%������meanlbfb��ѡȡ���� 16�����ݲ��Լ�y��Ӧ�������d ( y,d)

svmStruct = svmtrain(train, trainlabel); %svmtrain ��matlab�Դ�������
%[outclass,classified,f] = svmclassify(svmStruct,test); %svmclassifyҲ
outclass = svmclassify(svmStruct,test); %svmclassifyҲ

%pallfb(:,i)=f;
allrealkfb{i,1}=testlabel';
allkindsfb{i,1}=outclass;
allacfb(i,1)=1-sum(abs(outclass'-testlabel))/2/50
end

meanac=mean(allacfb);  %300����������ƽ��׼ȷ��
end
