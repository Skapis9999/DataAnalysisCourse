clc
clear
clf
%m = 1000; %samples
n = 100; %systems
lambda = 15; %lamda
meanV =[ ]; %mean


v = exprnd(lambda,1,n);
%figure(1)
%plot(v)
h = ttest(v,lambda,'Alpha',0.05);
%The returned value h = 0 indicates that...
%ttest does not reject the null hypothesis...
%at the 5% significance level.

m = 1000; %samples
n = 1000; %systems
y=0;
x = NaN*ones(m,1);
ci = NaN*ones(2,m);
nbin =  round(sqrt(m/5));
alpha = 0.05;
%nbin =round(sqrt(m));

for i = 1:m
     x = exprnd(lambda,1,n);
     %h = 1-ttest(v,lambda,'Alpha',alpha);
     [h(i),p,ci(:,i)] = ttest(x,lambda,'Alpha',alpha);
     y = y + h(i) ;
     
end


hist(ci(1,:),nbin)
hold on
ci
fprintf('Estimated probability of rejection=%1.1f%% \n',y/m*100);
ax = axis;
plot(lambda*[1 1],[ax(3) ax(4)],'r')
xlabel(sprintf('lower limit of CI for mean [P(lower>tau)=%1.3f]',...
    length(find(ci(1,:)>lambda))/m))
ylabel('counts')
title(sprintf('Exponential: tau=%2.2f M=%d n=%d CI-lower for alpha=%1.3f',...
    lambda,m,n,alpha))





