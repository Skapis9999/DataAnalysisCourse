% Chapter 3 Exercise 9
%clf
clear all
n = 10;             %size of sample x
m = 12;             %size of sample y
M= 100;             %number of samples
mu = 0;
sigma = 1;
alpha = 0.05;
B = 1000;
nbins = 20;

valuesX = normrnd(mu,sigma, [M,n]);         %M x n array of X values
valuesY = normrnd(mu,sigma, [M,m]);         %M x m array of Y values

k= NaN(M,2);
for i = [1:M]
    [h,p,ci,stats] = ttest2(valuesX(i,:),valuesY(i,:),'Alpha', alpha);
    k(i,1)=ci(1);
    k(i,2)=ci(2);
end
figure(1)
clf;
histfit(k(:,1),nbins);
hold on
histfit(k(:,2),nbins);
legend('lower limit','', 'uper limit','')

%(ii)
r = NaN(B,1);
sX = NaN(B,n);
sY = NaN(B,m);
c = NaN(2,M);
%typecast(X,'uint16')
% X = int16(-1)
% maxV = typecast((B+1)*alpha/2,'uint16');
% minV = typecast((B+1)*(1-alpha/2),'uint16');
maxV = int16((B+1)*alpha/2);
minV = int16((B+1)*(1-alpha/2));
for iM=1:M
    for iB=1:B
        rV = unidrnd(n,n,1);
        sX(iB,:) = valuesX(iM, rV);
        rV = unidrnd(m,m,1);
        sY(iB,:) = valuesY(iM, rV);
    end
    r(:) = mean(sX')'- mean(sY')';
    rSorted = sort(r);
    c(1,iM) = rSorted(minV);
    c(2,iM) = rSorted(maxV);
end




% 
% v= NaN(maxV-minV,1);
% 
% for j=minV:maxV
%     v(j-minV+1) = rSorted(j);
% end  

figure(2)
clf;
histfit(c(1,:),nbins);
hold on
histfit(c(2,:),nbins);
legend('uper limit','', 'lower limit','')
