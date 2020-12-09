% Chapter 4 Exercise 1
%clc
clearvars



%(1_a)
h1=100;                     %starting throwing hight
h2 = [60, 54, 58, 60, 56];  %measurements 
sH=0;                       %uncertainty
e0 = 0.76;                  % expected coefficient
alpha = 0.05;
M =1000; %number of experiments 
n = 5;   %number of throws per experiment
mu = 58;
sigma = 2;


eV=sqrt(h2(:)./h1);
eM= mean(eV);
esd = std(eV);
% for i=[1,length(h2)]
%      sH = sH + (eM-eV(i))^2/(length(h2)-1);
% end
% %
% result = sqrt(sH);


% result= sqrt(sH);
fprintf("Precision is %2.4f meters \n", esd);       %precision sv

x = tinv(1-alpha/2,length(h2)-1); 

fprintf("Precision limit is %2.4f\n", x*esd);       %precision limit t*sv with confidence interval alpha



%(1_b)
k = NaN(n,1);
ksd = NaN(M,1);
kM = NaN(M,1);
eCor = NaN(n,1);
esdV = NaN(M,1);
emeanV = NaN(M,1);
for i=1:M
    k = normrnd(mu,sigma,[1,n]);            %n throws
    kM(i) = mean(k);                        %means
    ksd(i) = std(k);                        %stds
    eCor=sqrt(k(:)./h1);                    %corelation factors
    esd(i) = std(eCor);                     %std of COR
    eM(i) = mean(eCor);                     %mean of COR
end

mue = sqrt(mu / h1);                                %mean of e
sigmae = 0.5*sqrt(1/h1)*sqrt(1/mu)*sigma;           %std of e by law of propagation of errors 

figure(1)
clf
histfit(kM)
hold on
ax = axis;
plot(mu*[1 1],[ax(3) ax(4)],'r')
title('Mean of h2')

figure(2)
clf
histfit(ksd)
hold on
ax = axis;
plot(sigma*[1 1],[ax(3) ax(4)],'r')
title('Std of h2')

figure(3)
clf
histfit(eM)
hold on
ax = axis;
plot(mue*[1 1],[ax(3) ax(4)],'r')
title('Mean of e')

figure(4)
clf
histfit(esd)
hold on
ax = axis;
plot(sigmae*[1 1],[ax(3) ax(4)],'r')
title('Std of e')


%(1_c)

h = NaN(2,5);
% h1 80 100 90 120 95
% h2 48 60 50 75 56
h1 = [ 80 100 90 120 95];
h2 = [ 48 60 50 75 56 ];

eV = sqrt(h2 ./ h1);


h1sd = std(h);
h2sd = std(h2);
h1mean = mean(h1);
h2mean = mean(h2);
esd = std(eV);
eM = mean(eV);


for i= 1:length(h2)
     sH = sH + (eM-eV(i))^2/(length(h2)-1);
end
%
result = sqrt(sH)/sqrt(n);

fprintf("Precision is %2.4f meters \n", result);       %precision sv


t = tinv(1-alpha/2,length(h2)-1); 

v1 = eM - t * result;
v2 = eM + t * result;

fprintf("Limits are [%2.4f, %2.4f] and my value is %2.4f \n", v1,v2,e0);