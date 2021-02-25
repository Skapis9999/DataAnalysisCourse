% Kapoglis Konstantinos 9433
% Skapetis Christos 9378

clear all

countryNames = ["Belgium","UK", "Ireland", "Germany", "Norway", "Italy", "Austria", "Sweden",...
    "Switzerland", "Spain", "Slovakia", "Slovenia"];
caseDistribution = ["Lognormal", "Negative Binomial","Lognormal","Negative Binomial","Lognormal",...
    "Lognormal", "Lognormal","Extreme Value","Negative Binomial","Lognormal",...
    "Logistic","Lognormal"];
deathDistribution = ["Lognormal", "Rician", "Rayleigh","Rayleigh","Rician","Rician",...
    "Lognormal", "Rician","Rician","Lognormal",...
    "Rician","Rician"];

world = table2array(readtable('Covid19Confirmed.xlsx','Range','D1:MM157'));
worldDeaths = table2array(readtable('Covid19Deaths.xlsx','Range','D1:MM157'));
j = 0;
if(world(1,1) < 43830)   %43831 is the first date
    j = -1;
end
countryIDs = [14+j, 148+j, 66+j, 53+j, 104+j, 68+j, 9+j,...
    134+j, 135+j, 131+j, 125+j, 126+j];

startWave = [63, 69, 72, 64, 62, 56, 68, 64, 64, 65, 70, 65];
endWave = [200, 200, 158, 200, 137, 172, 153, 200, 138, 185, 131, 135];

N_countries = length(countryIDs);
peakDiff = NaN(1,N_countries );
peakDiffReal = NaN(1,N_countries );

waveD2 = endWave - startWave;

for country = 1:N_countries
    peakDiff(country) = findMax(caseDistribution,deathDistribution,country,waveD2(country));
    peakDiffReal(country) = ...
        findMaxReal(world, worldDeaths, countryIDs, country, startWave, endWave);
end

alpha = 0.05;
B = 1000;
bins = 100;
lowBoot = floor((B+1)*alpha/2);
upBoot = floor(B-1-lowBoot);
bootmxV = NaN(B,1);
for iB=1:B
    rV = unidrnd(N_countries,N_countries,1);
    xbV = peakDiffReal(rV);
    bootmxV(iB) = mean(xbV);
end

figure(1)
clf
hist(bootmxV, bins)
grid on
hold on;
yaxV = ylim;
m2 = sort(bootmxV);
plot(m2(lowBoot)*[1 1],yaxV,'r')
plot(m2(upBoot)*[1 1],yaxV,'r')
hold on;
yaxV = ylim;
plot(14*[1 1],yaxV,'g')
xlabel('$\bar{x}$','Interpreter','latex')
ylabel('bootstrap $\bar{x}$','Interpreter','latex')
title(sprintf('Peak difference from samples, \nB =%d bootstrap means for sample of n countries= %d',B,N_countries))

[h1, p, ci, stats] = ttest(peakDiffReal,14);
%
lowBoot = floor((B+1)*alpha/2);
upBoot = floor(B-1-lowBoot);
bootmxV = NaN(B,1);
for iB=1:B
    rV = unidrnd(N_countries,N_countries,1);
    xbV = peakDiffReal(rV);
    bootmxV(iB) = mean(xbV);
end
figure(2)
clf
hist(bootmxV, bins)
hold on;
grid on
yaxV = ylim;
m2 = sort(bootmxV);
plot(m2(lowBoot)*[1 1],yaxV,'r')
plot(m2(upBoot)*[1 1],yaxV,'r')
hold on;
yaxV = ylim;
plot(14*[1 1],yaxV,'g')
xlabel('$\bar{x}$','Interpreter','latex')
ylabel('bootstrap $\bar{x}$','Interpreter','latex')
title(sprintf('Peak difference from estimation, \nB =%d bootstrap means for sample of n countries= %d',B,N_countries))

[h2,p2,ci2,stats] = ttest(peakDiff,14);

function dateGap = findMax(caseDistribution,deathDistribution,i,N)
x = 1:N; %N is the wave duration
pd = zeros(2, N);

pd_model = fitdist((x)', caseDistribution(i));
pd(1, :) = pdf(pd_model,x);
[~,i1] = max(pd(1, :));
pd_model = fitdist((x)', deathDistribution(i));
pd(2, :) = pdf(pd_model,x);
[~,i2] = max(pd(2, :));
dateGap = i2-i1;
end

function dateGap = findMaxReal(world, worldDeaths, countryIDs, country, startWave, endWave)
    x_Country = startWave(country):1:endWave(country);
    wave1 = world(countryIDs(country), x_Country);
    wave1(isnan(wave1))=0;
    deaths1 = worldDeaths(countryIDs(country), x_Country);
    deaths1(isnan(deaths1))=0;
    wave= wave1/sum(wave1);
    deaths = deaths1/sum(deaths1);
    [~, I] = max(wave);
    [~, I2] = max(deaths);
    dateGap = I2-I;
end

% Real       [-2, -2, 16, 19, 18, 6, 27,  4, -21, 84, -1, 8]
% Estimation [0,  23, 21, 22, 20, 31, 0, -30, 12,  0, -5, 18]

% The bootstrap method for both the real and estimated peak difference
% between the deaths and the cases has shown that we cannot reject the mean
% being 14 days.

% For both the real and estimated difference of the peaks between deaths
% and cases the ttest results in a failure to reject the null hypothesis
% for the mean to be 14.
