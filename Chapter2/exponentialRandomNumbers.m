%create 1000 random numbers with exponential  with ë=1 
%using  y=-(1/ë)*log(1-x)
clc
clf                         %clears plot
lamda = 1;                  %ë
bins=10;
n = 1000;

rV = rand(1,n);           %1000 random numbers from 0 to 1
yV = -(1/lamda)*log(1-rv);    %1000 random numbers with exponential

[Ny,Xy]=hist(yV,bins);  % Xy has the centers of bins, Ny the frequencies

%hist(x)                     %creating a histogram
hold                        %holds to fit both plots
ypdfV = lamda * exp(-lamda*Xy);  %pdf
ypdfV = ypdfV / sum(ypdfV);
figure(1)

plot(Xy,Ny/n,'.-k')
plot(Xy,ypdfV/5,'c')

 legend('simulated','analytic')
 xlabel('x')
 ylabel('f_X(x) - relative frequency scale')
 title(['Exponential distribution from ',int2str(n),' samples'])
%plot(pdf('exponential', X, x))

% ypdfV = lambda*exp(-lambda*Xy);
% ypdfV = ypdfV / sum(ypdfV);
% figure(1)
% clf
% plot(Xy,Ny/n,'.-k')
% hold on
% plot(Xy,ypdfV,'c')
% legend('simulated','analytic')
% xlabel('x')
% ylabel('f_X(x) - relative frequency scale')
% title(['Exponential distribution from ',int2str(n),' samples'])