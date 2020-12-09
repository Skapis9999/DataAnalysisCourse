% Chapter 4 Exercise 3
%clc
clearvars

M= 1000;
meanV = 77.78;
sigmaV = 0.71;
meanI = 1.21;
sigmaI = 0.071;
meanF = 0.283;
sigmaF = 0.017;
covVF = 0.5;

% (a) uncertainty

sigmaP = sqrt((meanI*cos(meanF))^2*sigmaV^2+...
    (meanV*cos(meanF))^2*sigmaI^2+...
    (meanV*meanI*(-sin(meanF)))^2*sigmaF^2);

% (b)
values = NaN(M,3);  %V ,I and F 
p = NaN(M,1);
sigmaP2 = NaN(M,1);

%meanP = 

for i = 1:M
    values(i,1) = normrnd(meanV,sigmaV);    %random v
    values(i,2) = normrnd(meanI,sigmaI);    %random i
    values(i,3) = normrnd(meanF,sigmaF);    %random f
    p(i) = values(i,1)*values(i,2)*cos(values(i,3)); %random p
    %sigmaP2(i) = (p(i)- mean(p))^2;
end

%sigma = (sum(sigmaP2) / sqrt(M-1))/sqrt(M);
std(p);

fprintf("We were expecting an uncertainty of %2.4f and our data had an uncertainty of %2.4f  \n", sigmaP, std(p));

% (c)
sigmaP2 = sqrt((meanI*cos(meanF))^2*sigmaV^2+...
    2*(meanI*cos(meanF))*meanV*meanI*(-sin(meanF))*covVF*sigmaV*sigmaF+...
    (meanV*cos(meanF))^2*sigmaI^2+...
    (meanV*meanI*(-sin(meanF)))^2*sigmaF^2);

Sigma = [sigmaI^2 0 0;...
    0 sigmaV^2 covVF*sigmaV*sigmaF;...
    0 covVF*sigmaV*sigmaF sigmaF^2]; 
mu=[meanI, meanV, meanF];
r = mvnrnd(mu,Sigma,M);

p(:)= r(:,1).*r(:,2).*cos(r(:,3));
fprintf("We were expecting an uncertainty of %2.4f and our data had an uncertainty of %2.4f  \n", sigmaP2, std(p));
