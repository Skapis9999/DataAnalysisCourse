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
r = NaN(B, 1);
d = NaN(B, 1);
sX = NaN(B, n);
sY = NaN(B, m);
sZ = NaN(B, m+n);
c = NaN(2,M);
c_1 = NaN(2,M);
meanval = NaN(M, 1);


maxV = int16((B+1)*alpha/2);
minV = int16((B+1)*(1-alpha/2));
Z = [valuesX valuesY];
for iM=1:M
    for iB=1:B
        rZ = unidrnd(n + m,n + m,1);
        rV = unidrnd(n,n,1);
        sX(iB,:) = valuesX(iM, rV);
        rV = unidrnd(m,m,1);
        sY(iB,:) = valuesY(iM, rV);
        sZ(iB,:) = Z(iM, rZ);
    end
    r(:) = mean(sX')'- mean(sY')';
    sZ_1 = sZ(:, 1:n);
    sZ_2 = sZ(:, n+1:m);
    d(:) = mean(sZ_1')'- mean(sZ_2')';
    rSorted = sort(r);
    dSorted = sort(d);
    c(1,iM) = rSorted(minV);
    c(2,iM) = rSorted(maxV);
    c_1(1,iM) = dSorted(minV);
    c_1(2,iM) = dSorted(maxV);
end


figure(2)
clf;
histfit(c(1,:),nbins);
hold on
histfit(c(2,:),nbins);
legend('lower limit','', 'uper limit','')

meanval(:) = mean(valuesX')'- mean(valuesY')';

figure(3)
clf;
histfit(c_1(1,:),nbins);
hold on
histfit(c_1(2,:),nbins);
hold on
histfit(meanval(:),nbins);
legend('upper limit','', 'lower limit','', 'mean limit','' )

