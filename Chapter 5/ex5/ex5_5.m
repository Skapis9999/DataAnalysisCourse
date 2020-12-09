%unidrnd(N,n,1)

% Exercise 5.5
datdir = 'E:\Έγγραφα2\Σπουδές\7ο Εξάμηνο\Ανάλυση Δεδομένων\Ανάλυση ασκήσεις\Chapter 5\ex4\';
dattxt = 'lightair';

xyM = load([datdir,dattxt,'.dat']);
xV = xyM(:,1);
yV = xyM(:,2);
l = length(xV);


n = 100; %sample size
M = 1000;   %bootstrap samples
alpha = 0.05;

cor = NaN(M,1);
v = NaN(n,1);
d = NaN(n,1);
s = NaN(n,1);
b0V = NaN(M,1);
b1V = NaN(M,1);

for i = 1:M
    v = unidrnd(l,n,1);
    d(:) = xV(v(:));
    s(:) = yV(v(:));
    c = corrcoef(s,d);
    cor(i) = c(1,2);
    sigmaXX= std(d);
    sigmaYY = std(s);
    sigmaXY = cor(i)*sigmaXX*sigmaYY;
    b1=sigmaXY/sigmaXX^2;
    b0=mean(s)-b1*mean(d);
    b0V(i) = b0;
    b1V(i) = b1;
end

b0 = sort(b0V);
b1 = sort(b1V);
lower = M * alpha/2;
upper = M * (1-alpha/2);
fprintf('bo limits are = [%1.4f, %1.4f] \n',b0(lower), b0(upper));
fprintf('b1 limits are = [%1.4f, %1.4f] \n',b1(lower), b1(upper));


%from 5_4
sigmaXX=0;
sigmaXY=0;
for i=1:n
    sigmaXX=sigmaXX+(xV(i)-mean(xV))^2;
end
for i=1:n
    sigmaXY=sigmaXY+((xV(i)-mean(xV)))*((yV(i)-mean(yV)));
end
sigmaXX = sigmaXX/(n-1);
sigmaXY = sigmaXY/(n-1);
preb1=sigmaXY/sigmaXX;
preb0=mean(yV)-preb1*mean(xV);
error = NaN(n,1);
error(:)= yV(:) - preb0 - preb1*xV(:);
se = std(error);
sigmab1=se/sqrt(sigmaXX*(n-1));
tcrit = tinv(1-alpha/2,n-2);
b1ci=[preb1-tcrit*sigmab1, preb1+tcrit*sigmab1];
sigmab0 = se * sqrt((1/n)+ mean(xV)^2/(sigmaXX*(n-1)));
b0ci=[preb0-tcrit*sigmab0, preb0+tcrit*sigmab0];

%plots
nbins=100;
figure(1)
clf
histfit(b0,nbins)
hold on
ax = axis;
plot(b0(lower)*[1 1],[ax(3) ax(4)],'r')
hold on
plot(b0(upper)*[1 1],[ax(3) ax(4)],'r')
hold on
plot(b0ci(1)*[1 1],[ax(3) ax(4)],'y')
hold on
plot(b0ci(2)*[1 1],[ax(3) ax(4)],'y')
title(sprintf('bo limits and old b0 limits '))

figure(2)
clf
histfit(b1,nbins)
hold on
ax = axis;
plot(b1(lower)*[1 1],[ax(3) ax(4)],'r')
hold on
plot(b1(upper)*[1 1],[ax(3) ax(4)],'r')
hold on
plot(b1ci(1)*[1 1],[ax(3) ax(4)],'y')
hold on
plot(b1ci(2)*[1 1],[ax(3) ax(4)],'y')
title(sprintf('b1 limits and old b1 limits '))


