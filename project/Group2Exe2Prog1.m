% Kapoglis Konstantinos 9433
% Skapetis Christos 9378

% issues: UK deaths N/A MSE solved

% Countries:
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
% UK        Rayleigh                Rayleigh
% Ireland   Rayleigh                Rayleigh
% Germany   Rayleigh                Rayleigh
% Norway    Lognormal               Rician
% Italy     Negative Binomial       Rician
% Austria   Rayleigh                Rayleigh
% Sweden    Rayleigh                Rician
% Switzerland Rayleigh              Rician
% Spain     Rayleigh                Rayleigh
% Slovakia  Rayleigh                Rician
% Slovenia  Rayleigh                Rician
clear all

world = table2array(readtable('Covid19Confirmed.xlsx','Range','D1:MM157'));
worldDeaths = table2array(readtable('Covid19Deaths.xlsx','Range','D1:MM157'));

i = 0;
if(world(1,1) < 43830)   %43831 is the first date
    i = -1;
end
%the right id is the real id+i
N_countries = 12;
MSE_Cases_Values = zeros(4, N_countries);       %1 and 3 for Rayleigh 2 and 4 for optimal for cases and deaths

pd_count = 17;
MSE_Cases = zeros(pd_count, N_countries);
MSE_Deaths = zeros(pd_count, N_countries);
Dist_Names = strings(pd_count, N_countries);
pd_cases = strings(pd_count, N_countries);
pd_deaths = strings(pd_count, N_countries);

countryNames = ["UK", "Ireland", "Germany", "Norway", "Italy", "Austria", "Sweden",...
    "Switzerland", "Spain", "Slovakia", "Slovenia"];

UKID = 148+i;
StartUK = 60;
EndUK = 200;
x_UK = StartUK:1:EndUK;
waveUK1 = world(UKID, x_UK);
DeathsUK1 = worldDeaths(UKID, x_UK);
DeathsUK1(isnan(DeathsUK1))=0;
N = length(waveUK1);
pd = zeros(pd_count, N);
x = 1:N;
waveUK= waveUK1(x)/sum(waveUK1(x));
deathsUK = DeathsUK1/sum(DeathsUK1);
deathsUK(isnan(deathsUK))=0;
[pd, Dist_Names] = AllDistributions(x, pd, Dist_Names, 1);
[pd_cases(:, 1), pd_deaths(:, 1),MSE_Cases_Values(:,1)] = mse(waveUK, deathsUK, pd ,MSE_Cases, MSE_Deaths, Dist_Names, 1);

% for pdi = 1:pd_count
%     figure(pdi+1)
%     clf
%     plot(x, pd(pdi, :), 'LineWidth',2)
%     hold on
%     plot(deathsUK)
% end

IrelandID = 66+i;
StartIreland = 65;
EndIreland = 176;
x_Ireland = StartIreland:1:EndIreland;
waveIreland1 = world(IrelandID, x_Ireland);
waveIreland1(isnan(waveIreland1)) = 0;
DeathsIreland1 = worldDeaths(IrelandID, x_Ireland);
DeathsIreland1(isnan(DeathsIreland1))=0;
N = length(waveIreland1);
pd1 = zeros(pd_count, N);
x = 1:N;
waveIreland = waveIreland1(x)/sum(waveIreland1(x));
deathsIreland = DeathsIreland1(x)/sum(DeathsIreland1);
[pd1, Dist_Names] = AllDistributions(x, pd1, Dist_Names, 2);
[pd_cases(:, 2), pd_deaths(:, 2),MSE_Cases_Values(:,2)] = mse(waveIreland, deathsIreland, pd1 ,MSE_Cases, MSE_Deaths, Dist_Names, 2);
%  for pdi = 1:pd_count
%       figure(pdi+18)
%       clf
%       plot(x, pd1(pdi, :), 'LineWidth',2)
%       hold on
%       plot(waveIreland)
%  end

GermanyID = 53+i;
StartGermany = 60;
EndGermany = 150;
x_Germany = StartGermany:1:EndGermany;
waveGermany1 = world(GermanyID, x_Germany);
waveGermany1(isnan(waveIreland1)) = 0;
DeathsGermany1 = worldDeaths(GermanyID, x_Germany);
N = length(waveGermany1);
pd2 = zeros(pd_count, N);
x = 1:N;
waveGermany = waveGermany1(x)/sum(waveGermany1(x));
deathsGermany = DeathsGermany1(x)/sum(DeathsGermany1);
[pd2, Dist_Names] = AllDistributions(x, pd2, Dist_Names, 3);
[pd_cases(:, 3), pd_deaths(:, 3),MSE_Cases_Values(:,3)] = mse(waveGermany, deathsGermany, pd2 ,MSE_Cases, MSE_Deaths, Dist_Names, 3);
%  for pdi = 1:pd_count
%       figure(pdi+35)
%       clf
%       plot(x, pd2(pdi, :), 'LineWidth',2)
%       hold on
%       plot(waveGermany)
%  end

NorwayID = 104+i;
waveNorway1 = world(NorwayID, :);
DeathsNorway1 = worldDeaths(NorwayID, :);
StartNorway = 58;
EndNorway = 170;
x_Norway = StartNorway:1:EndNorway;
waveNorway1 = world(NorwayID, x_Norway);
DeathsNorway1 = worldDeaths(NorwayID, x_Norway);
N = length(waveNorway1);
pd3 = zeros(pd_count, N);
x = 1:N;
waveNorway = waveNorway1(x)/sum(waveNorway1(x));
deathsNorway = DeathsNorway1(x)/sum(DeathsNorway1);
[pd3, Dist_Names] = AllDistributions(x, pd3, Dist_Names, 4);
[pd_cases(:, 4), pd_deaths(:, 4),MSE_Cases_Values(:,4)] = mse(waveNorway, deathsNorway, pd3 ,MSE_Cases, MSE_Deaths, Dist_Names, 4);
%  for pdi = 1:pd_count
%      figure(pdi+52)
%      clf
%      plot(x, pd3(pdi, :), 'LineWidth',2)
%      hold on
%      plot(waveNorway)
%  end
 
ItalyID = 68+i;
StartItaly = 58;
EndItaly = 170;
x_Italy = StartItaly:1:EndItaly;
waveItaly1 = world(ItalyID, x_Italy);
DeathsItaly1 = worldDeaths(ItalyID, x_Italy);
N = length(waveItaly1);
pd4 = zeros(pd_count, N);
x = 1:N;
waveItaly = waveItaly1(x)/sum(waveItaly1(x));
deathsItaly = DeathsItaly1(x)/sum(DeathsItaly1);
[pd4, Dist_Names] = AllDistributions(x, pd4, Dist_Names, 5);
[pd_cases(:, 5), pd_deaths(:, 5),MSE_Cases_Values(:,5)] = mse(waveItaly, deathsItaly, pd4 ,MSE_Cases, MSE_Deaths, Dist_Names, 5);
%  for pdi = 1:pd_count
%       figure(pdi+69)
%       clf
%       plot(x, pd4(pdi, :), 'LineWidth',2)
%       hold on
%       plot(waveItaly)
%   end

AustriaID = 9+i;
StartAustria = 64;
EndAustria = 123;
x_Austria = StartAustria:1:EndAustria;
waveAustria1 = world(AustriaID, x_Austria);
DeathsAustria1 = worldDeaths(AustriaID, x_Austria);
N = length(waveAustria1);
pd5 = zeros(pd_count, N);
x = 1:N;
waveAustria = waveAustria1(x)/sum(waveAustria1(x));
deathsAustria = DeathsAustria1(x)/sum(DeathsAustria1);
[pd5, Dist_Names] = AllDistributions(x, pd5, Dist_Names, 6);
[pd_cases(:, 6), pd_deaths(:, 6),MSE_Cases_Values(:,6)] = mse(waveAustria, deathsAustria, pd5 ,MSE_Cases, MSE_Deaths, Dist_Names, 6);
%  for pdi = 1:pd_count
%       figure(pdi+69)
%       clf
%       plot(x, pd5(pdi, :), 'LineWidth',2)
%       hold on
%       plot(waveAustria)
%  end

SwissID = 135+i;
StartSwiss = 64;
EndSwiss = 139;
x_Swiss = StartSwiss:1:EndSwiss;
waveSwiss1 = world(SwissID, x_Swiss);
DeathsSwiss1 = worldDeaths(SwissID, x_Swiss);
N = length(waveSwiss1);
pd6 = zeros(pd_count, N);
x = 1:N;
waveSwiss = waveSwiss1(x)/sum(waveSwiss1(x));
deathsSwiss = DeathsSwiss1(x)/sum(DeathsSwiss1);
[pd6, Dist_Names] = AllDistributions(x, pd6, Dist_Names, 7);
[pd_cases(:, 7), pd_deaths(:, 7),MSE_Cases_Values(:,7)] = mse(waveSwiss, deathsSwiss, pd6 ,MSE_Cases, MSE_Deaths, Dist_Names, 7);
%  for pdi = 1:pd_count
%       figure(pdi+69)
%       clf
%       plot(x, pd6(pdi, :), 'LineWidth',2)
%       hold on
%       plot(waveSwiss)
%  end

SwedenID = 134+i;
StartSweden = 50;
EndSweden = 244;
x_Sweden = StartSweden:1:EndSweden;
waveSweden1 = world(SwedenID, x_Sweden);
DeathsSweden1 = worldDeaths(SwedenID, x_Sweden);
N = length(waveSweden1);
pd7 = zeros(pd_count, N);
x = 1:N;
waveSweden = waveSweden1(x)/sum(waveSweden1(x));
deathsSweden = DeathsSweden1(x)/sum(DeathsSweden1);
[pd7, Dist_Names] = AllDistributions(x, pd7, Dist_Names, 8);
[pd_cases(:, 8), pd_deaths(:, 8),MSE_Cases_Values(:,8)] = mse(waveSweden, deathsSweden, pd7 ,MSE_Cases, MSE_Deaths, Dist_Names, 8);
%  for pdi = 1:pd_count
%       figure(pdi+69)
%       clf
%       plot(x, pd7(pdi, :), 'LineWidth',2)
%       hold on
%       plot(waveSweden)
%  end

SpainID = 131+i;
StartSpain = 60;
EndSpain = 142;
x_Spain = StartSpain:1:EndSpain;
waveSpain1 = world(SpainID, x_Spain);
DeathsSpain1 = worldDeaths(SpainID, x_Spain);
N = length(waveSpain1);
pd8 = zeros(pd_count, N);
x = 1:N;
waveSpain1 = ResolvingNegativeValues(waveSpain1);
waveSpain = waveSpain1(x)/sum(waveSpain1(x));
deathsSpain = DeathsSpain1(x)/sum(DeathsSpain1);
[pd8, Dist_Names] = AllDistributions(x, pd8, Dist_Names, 9);
[pd_cases(:, 9), pd_deaths(:, 9),MSE_Cases_Values(:,9)] = mse(waveSpain, deathsSpain, pd8 ,MSE_Cases, MSE_Deaths, Dist_Names, 9);
%  for pdi = 1:pd_count
%       figure(pdi+69)
%       clf
%       plot(x, pd8(pdi, :), 'LineWidth',2)
%       hold on
%       plot(waveSpain)
%  end  

SlovakiaID = 125+i;
StartSlovakia = 66;
EndSlovakia = 105;
x_Slovakia = StartSlovakia:1:EndSlovakia;
waveSlovakia1 = world(SlovakiaID, x_Slovakia);
DeathsSlovakia1 = worldDeaths(SlovakiaID, x_Slovakia);
N = length(waveSlovakia1);
pd9 = zeros(pd_count, N);
x = 1:N;
waveSlovakia1(isnan(waveSlovakia1))=0;
DeathsSlovakia1(isnan(DeathsSlovakia1))=0;
waveSlovakia = waveSlovakia1(x)/sum(waveSlovakia1(x));
deathsSlovakia = DeathsSlovakia1(x)/sum(DeathsSlovakia1);
[pd9, Dist_Names] = AllDistributions(x, pd9, Dist_Names, 10);
[pd_cases(:, 10), pd_deaths(:, 10),MSE_Cases_Values(:,10)] = mse(waveSlovakia, deathsSlovakia, pd9 ,MSE_Cases, MSE_Deaths, Dist_Names, 10);
%  for pdi = 1:pd_count
%       figure(pdi+69)
%       clf
%       plot(x, pd9(pdi, :), 'LineWidth',2)
%       hold on
%       plot(waveSlovakia)
%  end 

SloveniaID = 126+i;
StartSlovenia = 68;
EndSlovenia = 117;
x_Slovenia = StartSlovenia:1:EndSlovenia;
waveSlovenia1 = world(SloveniaID, x_Slovenia);
DeathsSlovenia1 = worldDeaths(SloveniaID, x_Slovenia);
N = length(waveSlovenia1);
pd10 = zeros(pd_count, N);
x = 1:N;
waveSlovenia1(isnan(waveSlovenia1))=0;
DeathsSlovenia1(isnan(DeathsSlovenia1))=0;
waveSlovenia = waveSlovenia1(x)/sum(waveSlovenia1(x));
deathsSlovenia = DeathsSlovenia1(x)/sum(DeathsSlovenia1);
[pd10, Dist_Names] = AllDistributions(x, pd10, Dist_Names, 11);
[pd_cases(:, 11), pd_deaths(:, 11),MSE_Cases_Values(:,11)] = mse(waveSlovenia, deathsSlovenia, pd10 ,MSE_Cases, MSE_Deaths, Dist_Names, 11);
%  for pdi = 1:pd_count
%       figure(pdi+69)
%       clf
%       plot(x, pd10(pdi, :), 'LineWidth',2)
%       hold on
%       plot(waveSlovenia)
%  end 

fprintf('So our results are here: \n')
for j = 1:(N_countries-1)
    fprintf('---------------------------------------------\n')
    if((MSE_Cases_Values(1,j) > 0.8 * MSE_Cases_Values(2,j))&&(0.8 * MSE_Cases_Values(1,j) < MSE_Cases_Values(2,j)))
        fprintf('%s can use the default distribution (Rayleigh) for cases\n', countryNames(j))
    else
        fprintf('%s cannot use the default distribution (Rayleigh) for cases\n', countryNames(j))
        fprintf('%s is optimized with %s distribution for cases\n', countryNames(j),pd_cases(1,j))
    end
    fprintf('---------------------------------------------\n')
    if((MSE_Cases_Values(3,j) > 0.8 * MSE_Cases_Values(4,j))&&(0.8 * MSE_Cases_Values(3,j) < MSE_Cases_Values(4,j)))
        fprintf('%s can use the default distribution (Rayleigh) for deaths\n', countryNames(j))
    elseif(isnan(MSE_Cases_Values(3,j)))
        fprintf('Its the fucking UK It uses Rayleigh\n')
        continue;
    else
        fprintf('%s cannot use the default distribution (Rayleigh) for deaths\n', countryNames(j))
        fprintf('%s is optimized with %s distribution for deaths\n', countryNames(j),pd_deaths(1,j))
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

function [pd_cases, pd_deaths, info] = mse(cases, deaths, pd ,MSE_Cases, MSE_Deaths, Dist_Names, i)
pdc = size(pd, 1);
    for pdi =  1:pdc
        for sample = 1:length(cases)
            MSE_Cases(pdi, i) = MSE_Cases(pdi, i) + (cases(sample) - pd(pdi, sample))^2/length(cases);
        end
    end
[B, I] = sort(MSE_Cases(:, i));
pd_cases = Dist_Names(I, i);
 position = find(pd_cases == 'Rayleigh');
 info = [B(1) B(position)]; 
for pdi =  1:pdc
     for sample = 1:length(deaths)
         MSE_Deaths(pdi, i) = MSE_Deaths(pdi, i) + (deaths(sample) - pd(pdi, sample))/length(deaths);
     end
 end
 [B, I] = sort(MSE_Deaths(:, i));
 pd_deaths = Dist_Names(I, i);
 position = find(pd_cases == 'Rayleigh');
 info = [info B(1) B(position)]; 

end

function waveSpain = ResolvingNegativeValues(waveSpain)
   for i = 1:size(waveSpain')
    if(waveSpain(i)<0)
        temp = (waveSpain(i-1)+waveSpain(i)+waveSpain(i+1))/2;
        waveSpain(i-1) = temp;
        waveSpain(i) = temp;
        waveSpain(i+1)= temp;
    end
   end 
end

