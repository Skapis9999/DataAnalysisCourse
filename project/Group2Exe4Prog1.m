% Kapoglis Konstantinos 9433
% Skapetis Christos 9378
clear all

countryNames = ["Belgium", "UK", "Ireland", "Germany", "Norway", "Italy", "Austria", "Sweden",...
    "Switzerland", "Spain", "Slovakia", "Slovenia"];

caseDistribution = ["Lognormal", "Negative Binomial","Lognormal","Negative Binomial","Lognormal",...
    "Lognormal", "Lognormal","Extreme Value","Negative Binomial","Lognormal",...
    "Logistic","Lognormal"];

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

T = 40;
tmax = 20;
N_countries = length(countryIDs);
pearsonValues = zeros(40, N_countries); %40 because I get -20 to 20

for country = 1:N_countries
    x_Country= startWave(country):1:endWave(country);
    x_Country_Extended = (startWave(country)-tmax):1:(endWave(country)+tmax);
    wave1 = world(countryIDs(country), x_Country);
    wave1(isnan(wave1))=0;
    deaths1 = worldDeaths(countryIDs(country), x_Country_Extended);
    deaths1(isnan(deaths1))=0;
    N = length(wave1);
    wave= wave1;
    deaths = deaths1;
    sigmaX = std(wave);
    for t = 1:T
        y=deaths(t:endWave(country)-startWave(country)+t);
        y = y;
        sigmaY = std(y);        
        covXY = cov(wave ,y);
        pearsonValues(t, country)=covXY(1,2)/(sigmaX*sigmaY);
     end
end
   
 for pdi = 1:N_countries
     figure(pdi)
     clf
     plot((1-tmax:T-tmax), pearsonValues(:, pdi), 'LineWidth',2)
     title(sprintf('Pearson correlation coefficient \n for country %s ',countryNames(pdi)));
     xlabel('\tau')
     ylabel('r(\tau)');
     hold on
 end

maxPearsonValues = zeros(1,N_countries); 
for pdi = 1:N_countries
    [maximum,I] = max(max(pearsonValues(:, pdi)));
    maxPearsonValues(pdi) = find(pearsonValues(:, pdi)==maximum)-tmax;        %-20 so that I can have values from -20 to 20
end

for pdi = 1:N_countries

fprintf("Country %s has maximum correlation when deaths have a delay of %d days \n",...
    countryNames(pdi),maxPearsonValues(pdi))
end
%maxPearsonValues shows us that deaths indeed have a delay comparing with
%the cases in the most of the cases.
%In Task 4 the delay is [6,  1,  11, 14, 19, 7, 13 ,-18, 13, 8, 11, 12]
%In Task 3 the delay is [0,  23, 21, 22, 20, 31, 0, -30, 12,  0, -5, 18] for
%distribution and       [-2, -2, 16, 19, 18, 6, 27,  4, -21, 84, -1, 8] for data
%The 2 tasks do not give us the same result.
