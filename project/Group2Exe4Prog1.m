% Kapoglis Konstantinos 9433
% Skapetis Christos 9378

clear all

countryNames = ["Belgium", "UK", "Ireland", "Germany", "Norway", "Italy", "Austria", "Sweden",...
    "Switzerland", "Spain", "Slovakia", "Slovenia"];

caseDistribution = ["Rayleigh", "Rayleigh","Rayleigh","Rayleigh","Lognormal",...
    "Negative Binomial ", "Rayleigh","Rayleigh","Rayleigh","Rayleigh",...
    "Rayleigh","Rayleigh"];

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
pearsonValues = zeros(40, N_countries); %40 because I get -20 to 20

for country = 1:N_countries
    x_Country= startWave(country):1:endWave(country);
    x_Country_Extended = (startWave(country)-20):1:(endWave(country)+20);
    wave1 = world(countryIDs(country), x_Country);
    wave1(isnan(wave1))=0;
    deaths1 = worldDeaths(countryIDs(country), x_Country);
    deaths1(isnan(deaths1))=0;
    N = length(wave1);
    wave= wave1/sum(wave1);
    deaths = deaths1/sum(deaths1);
    for t = -20:0
        x=wave(-t+1:endWave(country)-startWave(country)+1);
        y=deaths((1):(endWave(country)-startWave(country)+1+t));
        sigmaX = std(x);
        sigmaY = std(y);
        covXY = cov(x,y);
        %r=cov(X,Y)/(sigmaX*sigmaY)
        pearsonValues(t+21, country)=covXY(1,2)/(sigmaX*sigmaY);
    end
     for t = 1:20
        x=wave(1:endWave(country)-startWave(country)+1-t);
        y=deaths((t+1):(endWave(country)-startWave(country)+1));
        sigmaX = std(x);
        sigmaY = std(y);
        covXY = cov(x,y);
        %r=cov(X,Y)/(sigmaX*sigmaY)
        pearsonValues(t+21, country)=covXY(1,2)/(sigmaX*sigmaY);
    end
end
   
 for pdi = 1:N_countries
     figure(pdi)
     clf
     plot(1:41, pearsonValues(:, pdi), 'LineWidth',2)
     hold on
 end

maxPearsonValues = zeros(1,N_countries); 
maxPearsonValuesIds = zeros(1,N_countries); 
for pdi = 1:N_countries
    [maximum,I] = max(max(pearsonValues(:, pdi)));
    maxPearsonValuesIds = I;
    maxPearsonValues(pdi) = find(pearsonValues(:, pdi)==maximum)-20;        %-20 so that I can have values from -20 to 20
end



