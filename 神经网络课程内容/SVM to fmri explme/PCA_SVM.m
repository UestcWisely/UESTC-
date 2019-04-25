%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% PCA_SVM and its application to finger motion%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%pre_process (omitted)
%%%%%translate *.img to *.mat
% clear all
% clc
% number=input('Please input data number: ')
% %number=160;
% a = spm_get(number,'*.img','Please choice data');
% [number,k]=size(a);
% %spm2 vesion
% aaa(1,:)= strrep(a(1,:), 'img','hdr');
% [hdr,otherendian] = spm_read_hdr(aaa(1,:));
% dim(1:3)=hdr.dime.dim(2:4);
% % ********fix base*************
% %temp=0;
% %i=2;
% tt=dim(1)*dim(2)*dim(3);
% aa=zeros(dim(1),dim(2));
% for i=1:number
%     aa=read_data(a(i,:),dim);
%     %temp=temp+y;
%     ss(:,i)=reshape(aa,tt,1);
%     i
% end
% clear tt aa a aaa hdr otherendian dim
load fmridata1.mat
clear s
%%%%% remove the baseline and the detrench
[m,n]=size(ss);
dma = spm_detrend(ss',2)';
%%%%% get the left and right hand motion data
d=zeros(m,60);
y=ones(1,60);%the index of the class
for i=1:6
    d(:,10*i-9:10*i)=dma(:,20*i+13:20*i+22);%delay 4s 
end
for i=1:2:6
    y(10*i-9:10*i)=-1;%left is -1   
end
%%%%% mask including the brain tissue
load new_mask.mat;
s=repmat(s,1,60);
maskdma=s.*d;
fdma1=maskdma;
D=fdma1;
clear dma fdma1 maskdma s d
%%%%% reduce the dimension of the data by PCA, projecting the orignal data
%%%%% to eigenspace
[s1,s2]=size(D);
meancol=mean(D,2);
for j=1:s2
    Dc(:,j)=D(:,j)-meancol;    
end
data=Dc'*Dc;
[u s v]=svd(data);
E=Dc*u*s^(-1/2);
Dp=E'*Dc;
clear Dc u s v data mean col
y=y';
for i=1:60
    if y(i,1)==-1
       y(i,1)=0;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% the projected data input to SVM
groups = y;
data=Dp';


%%%tranning

[svmStruct,svIndex] = svmtrain(data,groups);
[s1,s2]=size(svmStruct.SupportVectors);
%for i=1:60
    %if groups(i,1)==0
        %y(i,1)=-1;
    %else
        %y(i,1)=1;
    %end
%end
%y=-y;
%yy=y(svIndex);
%sv=data(svIndex,:);
%alphaHat = g(svIndex).*alpha(svIndex);
%svm_struct.Alpha = alphaHat;
[m,n]=size(data);
w0=zeros(n,1);
wp=zeros(n,1);
for i=1:s1    
    w0=w0+svmStruct.Alpha(i)*svmStruct.SupportVectors(i,:)';
end
wp=w0;%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%Testing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%[train, test] = crossvalind('holdOut',groups);
%cp = classperf(groups);
% Use a linear support vector machine classifier
%svmStruct1 = svmtrain(data(train,:),groups(train));
%classes = svmclassify(svmStruct,data(test,:));
% See how well the classifier performed
%classperf(cp,classes,test);
%cr=cp.CorrectRate
%      % a leave-one-out prediction error estimate.
%      load carbig
%      x = Displacement; y = Acceleration;
%      N = length(x);    
sse = 0; %i=1;
%w1=zeros(n,1);
%wp=zeros(n,1);
kk=10;
for i = 1:kk
    i
    [train,test] = crossvalind('LeaveMOut',m,10);    
    svmStruct = svmtrain(data(train,:),groups(train)); 
    [s1,s2]=size(svmStruct.SupportVectors);
    %w0=zeros(n,1);    
    %for i=1:s1
        %w0=w0+yy(i)*svmStruct.Alpha(i)*svmStruct.SupportVectors(i,:)';
        %w0=w0+svmStruct.Alpha(i)*svmStruct.SupportVectors(i,:)';
    %end
    %w1=w0;
    %wp=wp+w1;
    classes = svmclassify(svmStruct,data(test,:)); 
    cp = classperf(groups);
    classperf(cp,classes,test);    
    cr=cp.CorrectRate
    sse = sse + cr;
    clear cp£»
end
corrr = sse./kk
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%imaging
load new_mask.mat
w=E*wp;
w=s.*w;%mask
w_max=max(abs(w));
size_w=size(w,1);
for i=1:size_w    
    w(i,1)=w(i,1)./w_max;%normalize
end
figure
plot(w)
title('the left_right SDM on single')
ww=reshape(w,53,63,46);
%%%%%% projection to nomalized brain
lw_mat2img(ww);
save PCA_SVM_leftright_hand ww
