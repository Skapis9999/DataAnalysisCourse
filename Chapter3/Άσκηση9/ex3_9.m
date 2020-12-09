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

for i = [1:M]
    


    [h,p,ci,stats] = ttest2(valuesX(i,:),valuesY(i,:),'Alpha', alpha);


    %bootstat = bootstrp(B, @mean, valuesX(i,:), valuesX(i,:));
    bootstat1 = bootstrp(B, @mean, valuesX(i,:));
    bootstat2 = bootstrp(B, @mean,  valuesY(i,:));
    
end
for i = [1:B]
    k(i) =bootstat1(i)-bootstat2(i);
end
figure(1)
clf;

sortedK = sort(k);
for i = [1:B]
    k(i) =bootstat1(i)-bootstat2(i);
end

histfit(bootstat1,nbins);
hold on
histfit(bootstat2,nbins);
hold on
histfit(k,nbins);
xlabel('Values','Interpreter','latex')
ylabel('Frequency','Interpreter','latex')
title(sprintf('M=%1.0f samples of n=%1.0f and m=%1.0f size and B=%1.0f samples bootstrap ', M, n, m,B))
legend('valueX','', 'valueY','','difference of X-Y','')