%% Kapoglis Konstantinos 9433
%% Skapetis Christos 9378

% issues: UK deaths N/A MSE - solved

%% Countries:
% Original: Belgium
% -------------------
% name      pd_ids
% -------------------
% UK        1
% Ireland   2
% Germany   3
% Norway    4
% Italy     5
% Austria   6
% Sweden    7
% Switzerland 8
% Spain     9
% Slovakia  10
% Slovenia  11

% Conclusions:
% Country    Case Distribution     Death Distribution
%-----------------------------------------------------
% UK         Negative Binomial     Rician
% Ireland    Rayleigh              Rayleigh  
% Germany    Lognormal             Rayleigh   
% Norway     Negative Binomial     Rician
% Italy      Lognormal             Rician
% Austria    Lognormal             Lognormal
% Sweden     Extreme Value         Rician
% Switzerland Negative Binomial    Rician
% Spain      Lognormal             Lognormal
% Slovakia   Logistic              Rician
% Slovenia   Lognormal             Rician
clear all

world = table2array(readtable('Covid19Confirmed.xlsx','Range','D1:MM157'));
worldDeaths = table2array(readtable('Covid19Deaths.xlsx','Range','D1:MM157'));

j = 0;
if(world(1,1) < 43830)   %43831 is the first date
    j = -1;
end
%the right id is the real id+i
N_countries =11;
MSE_Cases_Values = zeros(4, N_countries);       %1 and 3 for Rayleigh 2 and 4 for optimal for cases and deaths

pd_count = 17;
MSE_Cases = zeros(pd_count, N_countries);
MSE_Deaths = zeros(pd_count, N_countries);
Dist_Names = strings(pd_count, N_countries);
pd_cases = strings(pd_count, N_countries);
pd_deaths = strings(pd_count, N_countries);
Start_Wave = zeros(1, N_countries);
End_Wave = zeros(1, N_countries);
countryNames = [ "UK", "Ireland", "Germany", "Norway", "Italy", "Austria", "Sweden",...
    "Switzerland", "Spain", "Slovakia", "Slovenia"];
countryIDs = [ 148+j, 66+j, 53+j, 104+j, 68+j, 9+j,...
    134+j, 135+j, 131+j, 125+j, 126+j];
Distribution = "Lognormal";

percentage = zeros(1, N_countries);
percentage(:) = 0.02;

for country = 1:N_countries
    world(countryIDs(country),(isnan(world(countryIDs(country), 1:200))))=0;
    worldDeaths(countryIDs(country),(isnan(worldDeaths(countryIDs(country), 1:200))))=0;
    [Start_Wave(country), End_Wave(country)] = findwave(percentage(country), world(countryIDs(country), 1:200));
    if(Start_Wave(country)==0)
        Start_Wave(country)=1
    end
    wave_x = uint8(Start_Wave(country)): uint8(End_Wave(country));
    wave = world(countryIDs(country), wave_x);
    wave = ResolvingNegativeValues(wave);
    deaths = worldDeaths(countryIDs(country), wave_x);
    deaths = ResolvingNegativeValues(deaths);
    figure(country)
    clf
    plot(wave)
    hold on
    N = length(wave);
    wave_p = wave(:)/sum(wave(:));
    deaths_p = deaths(:)/sum(deaths);
    pd = zeros(pd_count, N);
    [pd, Dist_Names] = AllDistributions(1:N, pd, Dist_Names, country);
    [pd_cases(:, country), pd_deaths(:, country), MSE_Cases_Values(:, country)] = mse(wave_p, deaths_p, pd ,MSE_Cases, MSE_Deaths, Dist_Names, country, Distribution);
end

% Old Cases: [60, 60, 65, 60, 58, 58, 64, 64, 50, 60, 66, 68];
% New Cases: [63, 69, 72, 64, 62, 56, 68, 64, 64, 65, 70, 65]
% Old Deaths: [180, 200, 176, 150, 178, 170, 123, 139, 244, 142, 105, 117];
% New Deaths: [200, 200, 158, 200, 137, 172, 153, 200, 138, 185, 131, 135]

fprintf('So our results are here: \n')
 for j = 1:N_countries
     fprintf('---------------------------------------------\n')
     if((MSE_Cases_Values(1,j) > 0.8 * MSE_Cases_Values(2,j))&&(0.8 * MSE_Cases_Values(1,j) < MSE_Cases_Values(2,j)))
         fprintf('%s can use the default distribution (%s) for cases\n', countryNames(j),Distribution)
     else
         fprintf('%s cannot use the default distribution (%s) for cases\n', countryNames(j), Distribution)
         fprintf('%s is optimized with distribution %s for cases\n', countryNames(j),pd_cases(1,j))
     end
     if((MSE_Cases_Values(3,j) > 0.8 * MSE_Cases_Values(4,j))&&(0.8 * MSE_Cases_Values(3,j) < MSE_Cases_Values(4,j)))
         fprintf('%s can use the default distribution (%s) for deaths\n', countryNames(j), Distribution)
     elseif(isnan(MSE_Cases_Values(3,j)))
         fprintf('Its the fucking UK It uses Rayleigh\n')
         continue;
     else
         fprintf('%s cannot use the default distribution (%s) for deaths\n', countryNames(j), Distribution)
         fprintf('%s is optimized with %s distribution for deaths\n', countryNames(j), pd_deaths(1,j))
     end
 end

function [pd, Dist_Names] = AllDistributions(x, pd, Dist_Names, i)
pd_model = fitdist((x)', 'Normal');
Dist_Names(1, i) = pd_model.DistributionName;
pd(1, :) = pdf(pd_model,x);

pd_model = fitdist((x)', 'Rayleigh');
Dist_Names(2, i) = pd_model.DistributionName;
pd(2, :)=pdf(pd_model,x);

pd_model = fitdist((x)', 'Exponential');
Dist_Names(3, i) =  pd_model.DistributionName;
pd(3, :)=pdf(pd_model,x);

pd_model = fitdist((x)', 'Rician');
Dist_Names(4, i) =  pd_model.DistributionName;
pd(4, :)=pdf(pd_model,x);

pd_model = fitdist((x)', 'Lognormal');
Dist_Names(5, i) =  pd_model.DistributionName;
pd(5, :)=pdf(pd_model, x);

pd_model = fitdist((x)', 'BirnbaumSaunders');
Dist_Names(6, i) =  pd_model.DistributionName;
pd(6, :)=pdf(pd_model, x);

pd_model = fitdist((x)', 'ExtremeValue');
Dist_Names(7, i) =  pd_model.DistributionName;
pd(7, :)=pdf(pd_model, x);

pd_model = fitdist((x)', 'Gamma');
Dist_Names(8, i) =  pd_model.DistributionName;
pd(8, :)=pdf(pd_model, x);

pd_model = fitdist((x)', 'GeneralizedExtremeValue');
Dist_Names(9, i) =  pd_model.DistributionName;
pd(9, :)=pdf(pd_model, x);

pd_model = fitdist((x)', 'HalfNormal');
Dist_Names(10, i) =  pd_model.DistributionName;
pd(10, :)=pdf(pd_model, x);

pd_model = fitdist((x)', 'InverseGaussian');
Dist_Names(11, i) =  pd_model.DistributionName;
pd(11, :)=pdf(pd_model, x);

pd_model = fitdist((x)', 'Kernel');
Dist_Names(12, i) =  pd_model.DistributionName;
pd(12, :)=pdf(pd_model, x);

pd_model = fitdist((x)', 'Logistic');
pd(13, :)=pdf(pd_model, x);
Dist_Names(13, i) =  pd_model.DistributionName;

pd_model = fitdist((x)', 'Nakagami');
pd(14, :)=pdf(pd_model, x);
Dist_Names(14, i) =  pd_model.DistributionName;

pd_model = fitdist((x)', 'NegativeBinomial');
pd(15, :)=pdf(pd_model, x);
Dist_Names(15, i) =  pd_model.DistributionName;

pd_model = fitdist((x)', 'tLocationScale');
pd(16, :)=pdf(pd_model, x);
Dist_Names(16, i) =  pd_model.DistributionName;

pd_model = fitdist((x)', 'Weibull');
pd(17, :) = pdf(pd_model, x);
Dist_Names(17, i) =  pd_model.DistributionName;

end

function [pd_cases, pd_deaths, info] = mse(cases, deaths, pd ,MSE_Cases, MSE_Deaths, Dist_Names, i, Distribution)
pdc = size(pd, 1);
for pdi =  1:pdc
    for sample = 1:length(cases)
        MSE_Cases(pdi, i) = MSE_Cases(pdi, i) + (cases(sample) - pd(pdi, sample))^2/length(cases);
    end
end
[B, I] = sort(MSE_Cases(:, i));
pd_cases = Dist_Names(I, i);
position = find(pd_cases == Distribution);
info = [B(1) B(position)];
for pdi =  1:pdc
    for sample = 1:length(deaths)
        MSE_Deaths(pdi, i) = MSE_Deaths(pdi, i) + (deaths(sample) - pd(pdi, sample))/length(deaths);
    end
end
[B, I] = sort(MSE_Deaths(:, i));
pd_deaths = Dist_Names(I, i);
position = find(pd_cases == Distribution);
info = [info B(1) B(position)];

end

function waveSpain = ResolvingNegativeValues(waveSpain)
len = size(waveSpain');
for i = 1:len
    if(waveSpain(i)<0 & i+1<len)
        temp = (waveSpain(i-1)+waveSpain(i)+waveSpain(i+1))/2;
        waveSpain(i-1) = temp;
        waveSpain(i) = temp;
        waveSpain(i+1)= temp;
    elseif(waveSpain(i)<0)
        temp = (waveSpain(i-3) + waveSpain(i-1)+waveSpain(i));
        waveSpain(i-2) = temp;
        waveSpain(i-1) = temp;
        waveSpain(i)= temp;
    end   
end
end

function [startwave, endwave] = findwave(percentage, cases)
    [M,I] = max(cases);
    mean7 = movmean(cases,3);       %second orisma is how many days you count to confirm the end or the start of a wave
    startwaveIndeces = find((mean7 < percentage * M));
    acceptableStart = startwaveIndeces < I;
    startwave = max(startwaveIndeces.*acceptableStart);
    acceptableEnd = startwaveIndeces > I;
    [maxValue,I] = max(acceptableEnd);
    endwave = startwaveIndeces(I(1));
    if(maxValue==0)
        endwave = length(cases);
    end
end
