clear all
%% variable initialization
L = 1000;
nbins = 50;
n = 20;
mux = 0;
muy = 0;
sigma_x = 1; 
sigma_y = 1;
p_1 = 0;
alpha = 0.05;
mu = [mux muy];
Sigma = [sigma_x^2 p_1*sigma_x*sigma_y; p_1*sigma_x*sigma_y sigma_y^2 ];
R = mvnrnd(mu, Sigma, n);
rand_X = NaN(20, 2);
R_1 = NaN(L, 1);
rand_X(:, 1) = R(:, 1);
for random_perm = 1:L
    r = randperm(n);
    rand_X(:, 2) = R(r, 2);
    cor = corrcoef(rand_X);
    R_1(random_perm) = cor(1,2);
end
cor = corrcoef(R);
R = cor(1,2);
to =  R*sqrt((n-2)./(1-R^2));
t = R_1.*sqrt((n-2)./(1-R_1.^2));
t_sort = sort(t)
tn_1 = t_sort(L*alpha/2);
tn_2 = t_sort(L*(1-alpha/2));
figure(1)
histogram(t_sort, nbins)
hold on
ax = axis;
plot(tn_1*[1 1],[ax(3) ax(4)],'r')
plot(tn_2*[1 1],[ax(3) ax(4)],'r')
plot(to*[1 1],[ax(3) ax(4)],'y')

xlabel('t')
ylabel('counts')
title(sprintf('ρ=%1.2f n=%d M=%d alpha=%1.2f', R, n, L, alpha));
pr = length(find(to>tn_1 & to<tn_2))/L;
