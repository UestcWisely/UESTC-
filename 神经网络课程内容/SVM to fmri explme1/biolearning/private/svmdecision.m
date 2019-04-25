function [out,f] = svmdecision(Xnew,svm_struct)
%SVMDECISION evaluates the SVM decision function

% Copyright 2004 The MathWorks, Inc.

sv = svm_struct.SupportVectors;
alphaHat = svm_struct.Alpha;
bias = svm_struct.Bias;
kfun = svm_struct.KernelFunction;
kfunargs = svm_struct.KernelFunctionArgs;

f = (sum(diag(alphaHat)*feval(kfun,sv,Xnew,kfunargs{:})) + bias)';

out = sign(f);