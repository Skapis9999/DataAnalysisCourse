% Chapter 5 Exercise 1
%clc
clearvars

M = 1000; %samples
n = 20; %sample size

mX = 0;
mY = 0;
sigmaX = 1;
sigmaY = 1;
rho = 0;
rho = 0.5;

alpha=0.05;
bins=100;


Sigma = [sigmaX^2 rho*sigmaX*sigmaY;...
        rho*sigmaX*sigmaY sigmaY^2]; 
mu=[mX, mY];

% R = mvnrnd(mu,Sigma,M);
% 
% R_1 = NaN(M, 2*n);
rV = NaN(M, 1);
for sample = 1:M
    R = mvnrnd(mu, Sigma, n);
%     R_1(sample, : )= R(:);
    rM=corrcoef(R);
    rV(sample) = rM(1,2);
end

z = NaN(M, 1);
z = 0.5*log((1+rV)./(1-rV));

zcrit = norminv(1-alpha/2);
sd = sqrt(1/(n-3));
zLower = z-zcrit*sd;
zUpper = z+zcrit*sd;
rLower = (exp(2*zLower)-1)./(exp(2*zLower)+1);
rUpper = (exp(2*zUpper)-1)./(exp(2*zUpper)+1);

figure(1)
clf
hist(rLower,bins)
hold on
ax = axis;
plot(rho*[1 1],[ax(3) ax(4)],'r')
hold on
hist(rUpper,bins)
xlabel('r')
ylabel('counts')
title(sprintf('rho=%1.2f n=%d M=%d alpha=%1.2f r-histogram',rho,n,...
    M,alpha))
%Fisher = ecmnfish(R_1,Sigma,Inv(Sigma),[M, 2*n]);
rholow = length(find(rho<rLower))*100/M;
rholow2 = length(find(rho>rUpper))*100/M;


%t = r* sqrt((n-2)/(1-r^2))
t = rV.*sqrt((n-2)./(1-rV.^2));
tcrit = tinv(1-alpha/2,n-2);

% tLower = t-tcrit*sd;
% tUpper = t+tcrit*sd;
% rLower = (exp(2*tLower)-1)./(exp(2*tLower)+1);
% rUpper = (exp(2*tUpper)-1)./(exp(2*tUpper)+1);
rholow = length(find(abs(t)<tcrit))*100/M;
fprintf('rho=%1.2f n=%d M=%d 1-alpha=%1.2f p(rho in [rl,ru])=%1.5f \n',...
    rho,n,M,1-alpha,rholow);