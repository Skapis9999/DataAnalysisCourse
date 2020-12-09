

min = 0;
max = 1;
n = 100;
N=1e4;
bins=1e3;
%m  %mean

% for i = 1:10000:100
%     y = min + (max-min)* randn(1, 100);
%     m(i) = mean(y);
% end

m = mean(rand(n, N));


fprintf('\n');
clf
figure(1)
histfit(m,bins)
xlabel('y')
ylabel('times')
legend('values',' bell-shaped curve of normal distribution')
title(sprintf('%1.0f means of %1.0f  numbers \n',N,n))
