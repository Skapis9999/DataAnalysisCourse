% Chapter 3 Exercise 6 
%  bootstrap standard error 
clf;
clear all;
n = 10;             %sample
B= 1000;            %bootstrap
nbins = 100;        %bins for hist

xV = normrnd(0,1,[n,1]);
% (c) If doexponential=1 do exponential transform first
e = exp(xV);
m = mean(xV);

bootV = NaN(B,1);

for i=1:B
    rY = unidrnd(n,n,1);
    x = xV(rY);
    bootV(i) = mean(x);
end

figure(1)

histfit(bootV,nbins);
hold on;
yaxV = ylim;
plot(m*[1 1],yaxV,'r')
xlabel('$\bar{x}$','Interpreter','latex')
ylabel('bootstrap $\bar{x}$','Interpreter','latex')
title(sprintf('B =%d bootstrap means for sample of n = %d',B,n))

se = std(xV);
m =  std(rY)/sqrt(n);
fprintf('%1.4f - %1.4f = %1.4f\n', se,  m, se-m);

m = mean(e);

bootV = NaN(B,1);

for i=1:B
    rY = unidrnd(n,n,1);
    x = e(rY);
    bootV(i) = mean(x);
end

figure(2)
histfit(bootV,nbins);
hold on;
yaxV = ylim;
plot(m*[1 1],yaxV,'r')
xlabel('$\bar{x}$','Interpreter','latex')
ylabel('bootstrap $\bar{x}$','Interpreter','latex')
title(sprintf('B =%d bootstrap means for sample of n = %d but exponential',B,n))

se = std(e);
m =  std(rY)/sqrt(n);
fprintf('%1.4f - %1.4f = %1.4f\n', se,  m, se-m);


