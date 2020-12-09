clearvars
datdir = 'E:\Έγγραφα2\Σπουδές\7ο Εξάμηνο\Ανάλυση Δεδομένων\Ανάλυση ασκήσεις\Chapter 5\ex4\';    %path
dat1txt = 'lightair';       %file name

lightair = load([datdir,dat1txt,'.dat']);   %load data

alpha = 0.05;   %alpha

xV = lightair(:,1);     %density X
yV = lightair(:,2);     %speed Y
n = length(xV);         %%number of pair of values

figure(1)
c = linspace(1,10,length(xV)); %just for colours 
scatter(xV,yV,[],c,'filled');       %scatter diagram
title(sprintf('Scatter Diagram'));

cor = corrcoef(yV,xV);          

fprintf('Correlation is = %1.4f  \n',cor(1,2));
%(b)
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
b1=sigmaXY/sigmaXX;
b0=mean(yV)-b1*mean(xV);

fprintf('Simple linear regression is = %1.4f %1.4f * x  \n',b0,b1);

error = NaN(n,1);
error(:)= yV(:) - b0 - b1*xV(:);

% figure(2)
% plotResiduals(fitlm(xV,yV),'probability')

% mdl = fitlm(xV,yV);
% 
% x = anova(mdl,'components');
% x(1,3)
se = std(error);
sigmab1=se/sqrt(sigmaXX*(n-1));
tcrit = tinv(1-alpha/2,n-2);
b1ci=[b1-tcrit*sigmab1, b1+tcrit*sigmab1];

sigmab0 = se * sqrt((1/n)+ mean(xV)^2/(sigmaXX*(n-1)));
b0ci=[b0-tcrit*sigmab0, b0+tcrit*sigmab0];

y = NaN(n,1);
y(:)=b1*xV(:)+b0;
%(c)
figure(2)
c = linspace(1,10,length(xV)); %just for colours 
scatter(xV,yV,[],c,'filled');
hold on
plot(xV,y,'r');
title(sprintf('Scatter Diagram with the line of method of least squares '));

y1 = NaN(n,1);
y1(:)=b1*xV(:)+b0ci(1);
y2 = NaN(n,1);
y2(:)=b1*xV(:)+b0ci(2);

figure(3)
c = linspace(1,10,length(xV)); %just for colours 
scatter(xV,yV,[],c,'filled');
hold on
plot(xV,y,'r');
hold on
plot(xV,y1,'g');
hold on
plot(xV,y2,'g');
title(sprintf('Scatter Diagram with the line of method of least squares but with b0 limits'));


y3 = NaN(n,1);
y3(:)=b1ci(1)*xV(:)+b0;
y4 = NaN(n,1);
y4(:)=b1ci(2)*xV(:)+b0;

figure(4)
c = linspace(1,10,length(xV)); %just for colours 
scatter(xV,yV,[],c,'filled');
hold on
plot(xV,y,'r');
hold on
plot(xV,y1,'g');
hold on
plot(xV,y2,'g');
hold on
plot(xV,y3,'y');
hold on
plot(xV,y4,'y');
title(sprintf('Scatter Diagram with the line of method of least squares but with b1 limits'));

%prediction
x1 = 1.29;
y1 = b0 + b1*x1;
k = tcrit*se*sqrt(1+1/n+(x1-mean(xV))^2/sigmaXX);
yci = [y1 - k, y1 + k];
km = tcrit*se*sqrt(1/n+(x1-mean(xV))^2/sigmaXX);
ymci = [y1 - km, y1 + km];
fprintf('Limits of an observation are = [%1.4f, %1.4f]   \n',yci(1),yci(2));
fprintf('Limits of median observation = [%1.4f, %1.4f]   \n',ymci(1),ymci(2));
%(d)
%cAir = c*(1-0.00029*d/d0);
c0 = 299792.458;
d0 = 1.29;
b0r = c0;
malakitsa = 0.00029;
b1r = -c0*malakitsa/d0;

figure(5)
c = linspace(1,10,length(xV)); %just for colours 
scatter(xV,yV,[],c,'filled');
hold on
plot(xV,y,'r');
hold on
y5 = NaN(n,1);
y5(:)=b1r*xV(:)+b0r;
plot(xV,y5-299000,'b');
hold on
plot(xV,y1,'g');
hold on
plot(xV,y2,'g');
hold on
plot(xV,y3,'y');
hold on
plot(xV,y4,'y');
title(sprintf('Scatter Diagram with experimental and real results'));

%k1 = (b1-b1r)*sqrt(sigmaXX)/se;
%b1rci = [

%k2 = (b0-b0r)/(se*sqrt(1/n+mean(xV^2/sigmaXX)));
%b0rci = [

tb1 = (b1 - b1r)/sigmab1;
pb1 = 2*(1-tcdf(abs(tb1),n-2));
tb0 = (b0 - (c0-299000)) / sigmab0;
pb0 = 2*(1-tcdf(abs(tb0),n-2));


% disp(pb0);      %probablity to accept
% disp(pb1);