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

world = table2array(readtable('Covid19Confirmed.xlsx','Range','D1:MM157'));
worldDeaths = table2array(readtable('Covid19Deaths.xlsx','Range','D1:MM157'));
j = 0;
if(world(1,1) < 43830)   %43831 is the first date
    j = -1;
end
countryIDs = [14+j, 148+j, 66+j, 53+j, 104+j, 68+j, 9+j,...
    135+j, 134+j, 131+j, 125+j, 126+j];

startWave = [60, 60, 65, 60, 58, 58, 64, 64, 50, 60, 66, 68];
endWave = [180, 200, 176, 150, 178, 170, 123, 139, 244, 142, 105, 117];

N_countries = length(countryIDs);
peakDiff = NaN(1,N_countries );
peakDiffReal = NaN(1,N_countries );

waveD = [180-60, 200-60, 176-65, 150-60, 170-58, 170-58, 123-64, 139-64,...
    244-50, 142-60, 105-66, 117-68];

waveD2 = endWave - startWave;

for country = 1:N_countries
    peakDiff(country) = findMax(caseDistribution,deathDistribution,country,waveD(country));
    peakDiffReal(country) = ...
        findMaxReal(world, worldDeaths, countryIDs, country, startWave, endWave);
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
title(sprintf('DISTRIBUTON B =%d bootstrap means for sample of n countries= %d',B,N_countries))

%[h,p,ci,stats] = ttest(m);
[h, p, ci, stats] = ttest(m,14);
%

m2 = bootstrp(B,@mean,peakDiffReal);
[fi,xi] = ksdensity(m2);
figure(2)
clf
plot(xi,fi)
hold on;
yaxV = ylim;
plot(mean(m2)*[1 1],yaxV,'r')
hold on;
yaxV = ylim;
plot(14*[1 1],yaxV,'g')
xlabel('$\bar{x}$','Interpreter','latex')
ylabel('bootstrap $\bar{x}$','Interpreter','latex')
title(sprintf('REAL SAMPLE B =%d bootstrap means for sample of n countries= %d',B,N_countries))

%[h,p,ci,stats] = ttest(m2);
[h2,p2,ci2,stats] = ttest(m2,14);

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
