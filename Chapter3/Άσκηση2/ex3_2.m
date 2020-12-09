clc
clear
clf
m = 1000; %samples
n = 1000; %size of samples
lambda = 5; %lamda
meanV =[ ]; %mean


 for i = 1:m
     v = exprnd(lambda,1,n);
     meanV(i) = mean(v);
 end
 
 hist(meanV);
 mean(meanV)