%For [0,20] I predict y deaths with x(t-τ) cases
%Compare and find best latency
%Diagnostic with standarised errror
%
% Kapoglis Konstantinos 9433
% Skapetis Christos 9378

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
Se = zeros(20,N_countries);
Mse = zeros(20,N_countries);
for country = 1:N_countries
    x_Country= startWave(country):1:endWave(country);
    x_Country_Extended = (startWave(country)-20):1:(endWave(country)+20);
    wave1 = world(countryIDs(country), x_Country);
    wave1(isnan(wave1))=0;
    deaths1 = worldDeaths(countryIDs(country), x_Country_Extended);
    deaths1(isnan(deaths1))=0;
    N = length(wave1);
    wave= wave1;
    deaths = deaths1;
    n = endWave(country)-startWave(country)+1;
    for t = 1:20
        xV = wave(1:n-t);
        yV = deaths(1+t:n);
        modelfun = @(b,xV)b(1)*xV(:)+b(2);
        beta0 = [1 1];
        mdl = fitnlm(xV, yV,modelfun,beta0);
        b = table2array(mdl.Coefficients(:,1));
        s = corrcoef(xV, yV);
        corr = s(1, 2);
        Sx = std(xV);
        Sy = std(yV);
        Sxy = corr *Sx*Sy;
        b1 = Sxy / Sx^2;
        b0 = mean(yV) - b1 * mean(xV);
        Se(t, country) = sqrt((n-1) * (Sy^2 - b1^2*Sx^2)/(n-2));
        Mse(t, country)=mdl.MSE;
%         figure(t)
%         scatter(xV, yV);
%         hold on
%         plot(xV, b(1)*xV(:)+b(2));
%         20*11 plots. DO NOT TRY IT!
    end
end


