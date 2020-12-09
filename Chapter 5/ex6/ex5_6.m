% Exercise 5.6

xV=[2,3,8,16,32,48,64,80];
yV=[98.2, 91.7, 81.3, 64, 36.4, 32.6, 17.1, 11.3];
n = length(xV);
alpha=0.05;

figure(1)
c = linspace(1,10,length(xV)); %just for colours 
scatter(xV,yV,[],c,'filled');       %scatter diagram
title(sprintf('Scatter Diagram'));

%I consider it a y=ax^b phenomenon 

%So the linear model is y' = ln(a)+â*x'
%y' = lny and x' = lnx

x = NaN(n,1);
y = NaN(n,1);
x(:) = log(xV(:));
y(:) = log(yV(:));

figure(2)
c = linspace(1,10,length(xV)); %just for colours 
scatter(x,y,[],c,'filled');       %scatter diagram
title(sprintf('Scatter Diagram'));

x2 = NaN(n,1);
y2 = NaN(n,1);
x2(:) = xV(:);
y2(:) = log(yV(:));

figure(3)
c = linspace(1,10,length(xV)); %just for colours 
scatter(x2,y2,[],c,'filled');       %scatter diagram
title(sprintf('Scatter Diagram'));

cor = corrcoef(y2,x2);          

fprintf('Correlation is = %1.4f  \n',cor(1,2));
sigmaXX=0;
sigmaXY=0;
for i=1:n
    sigmaXX=sigmaXX+(x2(i)-mean(x2))^2;
end
for i=1:n
    sigmaXY=sigmaXY+((x2(i)-mean(x2)))*((y2(i)-mean(y2)));
end
sigmaXX = sigmaXX/(n-1);
sigmaXY = sigmaXY/(n-1);
b1=sigmaXY/sigmaXX;
b0=mean(y2)-b1*mean(x2);

fprintf('Simple linear regression is = %1.4f %1.4f * x  \n',b0,b1);

error = NaN(n,1);
error(:)= y2(:) - b0 - b1*x2(:);


y = NaN(n,1);
y(:)=b1*x2(:)+b0;

figure(2)
c = linspace(1,10,length(x2)); %just for colours 
scatter(x2,y2,[],c,'filled');
hold on
plot(x2,y,'r');
title(sprintf('Scatter Diagram with the line of method of least squares with b1 = %1.4f and b0 = %1.4f', b1,b0));

a = exp(b0);

y(:)=a*exp(xV(:).*b1);
figure(3)
c = linspace(1,10,length(x2)); %just for colours 
scatter(xV,yV,[],c,'filled');
hold on
plot(x2,y,'r');
title(sprintf('Scatter Diagram with the line of method of least squares with b = %1.4f and a = %1.4f', b1,a));

% data(1,:)=xV(:);
% data(2,:)=yV(:);
% sys = arx(data,[1 1 0]);
% resid(data,sys)
