% Chapter 3 Exercise 7 
% Bootstrap 95%
clf;
clear all
n = 10;             %size of sample
M= 100;             %number of samples
nbins = 10;        %bins for hist
alpha = 0.05;       % 95%
B = 1000;           %for Bootstrp

r = normrnd(0, 1,[M,n]);        %samples X ~ N(0, 1)

for i=[1:M]
    [h,p,ci,stats] = ttest(r(i,:), 0, alpha);
    upper(i) = ci(2);
    lower(i) = ci(1);
end


for j=[1:M]
    ci2 = bootci(B,@mean,r(j,:));
    upperB(j) = ci2(2);
    lowerB(j) = ci2(1);
end
    



figure(1)
clf;

histfit(upper,nbins);
hold on
histfit(upperB,nbins);
xlabel('Upper confidence interval','Interpreter','latex')
ylabel('Frequency','Interpreter','latex')
title(sprintf('M=%1.0f samples of n=%1.0f size and B=%1.0f samples bootstrap Upper confidence interval', M, n,B))
legend('ttest','', 'bootstrap')


figure(2)
clf;

histfit(lower,nbins);
hold on
histfit(lowerB,nbins);
xlabel('Lower confidence interval','Interpreter','latex')
ylabel('Frequency','Interpreter','latex')
title(sprintf('M=%1.0f samples of n=%1.0f size and B=%1.0f samples bootstrap Lower confidence interval', M, n,B))
legend('ttest','', 'bootstrap')
%b

r2(:,:) = (r(:,:)).^2;

for i=[1:M]
    [h,p,ci,stats] = ttest(r2(i,:), 0, alpha);
    upper(i) = ci(2);
    lower(i) = ci(1);
end


for i=[1:M]
    ci2 = bootci(B,@mean,r2(j,:));
    upperB(j) = ci2(2);
    lowerB(j) = ci2(1);
end

figure(3)
clf;

histfit(upper,nbins);
hold on
histfit(upperB,nbins);
xlabel('Upper confidence interval','Interpreter','latex')
ylabel('Frequency','Interpreter','latex')
title(sprintf('M=%1.0f samples of n=%1.0f size and B=%1.0f samples bootstrap Upper confidence interval but for X^2', M, n,B))
legend('ttest','', 'bootstrap')

figure(4)
clf;

histfit(lower,nbins);
hold on
histfit(lowerB,nbins);
xlabel('Lower confidence interval','Interpreter','latex')
ylabel('Frequency','Interpreter','latex')
title(sprintf('M=%1.0f samples of n=%1.0f size and B=%1.0f samples bootstrap Lower confidence interval but for X^2', M, n,B))
legend('ttest','', 'bootstrap')