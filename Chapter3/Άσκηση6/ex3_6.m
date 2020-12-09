% Chapter 3 Exercise 6 
%  bootstrap standard error 
clf;
clear;
n = 10;             %sample
B= 1000;            %bootstrap
nbins = 100;        %bins for hist


r = normrnd(0, 1,[1,n]);        %sample

bootstat = bootstrp(B,@mean,r);
figure(1)

histfit(bootstat,nbins);
hold on;
yaxV = ylim;
plot(mean(r)*[1 1],yaxV,'r')
xlabel('$\bar{x}$','Interpreter','latex')
ylabel('bootstrap $\bar{x}$','Interpreter','latex')
title(sprintf('B =%d bootstrap means for sample of n = %d',B,n))

%(b)

se = std(bootstat);
m =  std(r)/sqrt(n);            %se( ?x)= ó/sqrt(n)
fprintf('%1.4f - %1.4f = %1.4f\n', se,  m, se-m);

%(c)
rV = normrnd(0, 1,[1,n]);           %n random numbers from 0 to 1
k =exp(rV);                         %n numbers with exponential using the previous n random numbers


bootstat2 = bootstrp(B,@mean,k);
figure(2)

histfit(bootstat2,nbins);
hold on;
yaxV = ylim;
plot(mean(k)*[1 1],yaxV,'r')
xlabel('$\bar{x}$','Interpreter','latex')
ylabel('bootstrap $\bar{x}$','Interpreter','latex')
title(sprintf('B =%d bootstrap means for sample of n = %d but exponential',B,n))
%(b)

se = std(bootstat2);
m =  std(k)/sqrt(n);
fprintf('%1.4f - %1.4f = %1.4f\n', se,  m, se-m);

