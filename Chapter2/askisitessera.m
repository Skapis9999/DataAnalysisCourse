%examine E[1/X] = 1/E[X]in [1,2]

clc

min = 1;
max = 2;
%min = 0;
%max = 1;
%min = -1;
%max = 1;
n= [10 100 1000 10000 1e5 1e6 1e7]; 
nn = length(n);

for i = 1:nn
    v =min + (max-min)* rand(n(i),1);
    %k(:,:) = 1/v(:,:);
    k = 1./v;
    a(i) = mean(k);
    b(i) = 1/mean(v);
    fprintf('\n');
    fprintf('E[1/X] = %3.3f 1/E[X]=%3.3f for n = %i \n',a,b,n(i));

end

fprintf('\n');
figure(1)
clf
plot(a(:),'.-c')
hold on
plot(b(:),'.-m')
legend('E[1/X]','1/E[X]')
xlabel('2^n')
ylabel('mean')
title(sprintf('Examine if E[1/x]=1/E[x], in [%1.0f,%1.0f]\n',min,max))

    