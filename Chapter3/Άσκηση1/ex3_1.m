clc
clear
clf
m = 1000; %samples
n = 1000; %size of samples
lambda = 1; %lamda
meanV =[ ]; %mean


 for i = 1:m
     v = poissrnd(lambda,1,n);
     meanV(i) = mean(v);
 end
 
 hist(meanV);
 mean(meanV)


