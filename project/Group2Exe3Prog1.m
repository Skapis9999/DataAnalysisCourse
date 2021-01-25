% Kapoglis Konstantinos 9433
% Skapetis Christos 9378

clear all

countryNames = ["Belgium","UK", "Ireland", "Germany", "Norway", "Italy", "Austria", "Sweden",...
    "Switzerland", "Spain", "Slovakia", "Slovenia"];
caseDistribution = ["Rayleigh", "Rayleigh","Rayleigh","Rayleigh","Lognormal",...
    "Negative Binomial ", "Rayleigh","Rayleigh","Rayleigh","Rayleigh",...
    "Rayleigh","Rayleigh"];
deathDistribution = ["Rayleigh", "Rayleigh","Rayleigh","Rayleigh","Rician",...
    "Rician", "Rayleigh","Rician","Rician","Rayleigh",...
    "Rician","Rician"];
N_countries = 12;
peakDiff = NaN(1,N_countries );
waveD = [180-60, 200-60, 176-65, 150-60, 170-58, 170-58, 123-64, 139-64,...
    244-50, 142-60, 105-66, 117-68];

for country = 1:N_countries
    peakDiff(country) = findMax(caseDistribution,deathDistribution,country,waveD(country));
end

alpha = 0.05;
B = 1000;
bins = 100;
m = bootstrp(B,@mean,peakDiff);
[fi,xi] = ksdensity(m);
figure(1)
clf
plot(xi,fi)
hold on;
yaxV = ylim;
plot(mean(m)*[1 1],yaxV,'r')
hold on;
yaxV = ylim;
plot(14*[1 1],yaxV,'g')
xlabel('$\bar{x}$','Interpreter','latex')
ylabel('bootstrap $\bar{x}$','Interpreter','latex')
title(sprintf('B =%d bootstrap means for sample of n countries= %d',B,N_countries))

[h,p,ci,stats] = ttest(m);
[h,p,ci,stats] = ttest(m,14);
%
function dateGap = findMax(caseDistribution,deathDistribution,i,N)
    x = 1:N; %N is the wave duration
    pd = zeros(2, N);
    
    pd_model = fitdist((x)', caseDistribution(i));
    pd(1, :) = pdf(pd_model,x);
    [m1,i1] = max(pd(1, :));
    
    pd_model = fitdist((x)', deathDistribution(i));
    pd(2, :) = pdf(pd_model,x);
    [m2,i2] = max(pd(2, :));
    dateGap = i2-i1;
end

