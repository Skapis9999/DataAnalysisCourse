% Chapter 5 Exercise 2
%clc
clearvars



L = 1000;
n = 20;

mX = 0;
mY = 100;
sigmaX = 1;
sigmaY = 1;
rho = 0;

alpha=0.05;
bins=100;

Sigma = [sigmaX^2 rho*sigmaX*sigmaY;...
        rho*sigmaX*sigmaY sigmaY^2]; 
mu=[mX, mY];

R = mvnrnd(mu, Sigma, n);
rM=corrcoef(R);
%rV(sample) = rM(1,2);
rX = R(:,1);
rY = R(:,2);

p = randperm(rX(:))
