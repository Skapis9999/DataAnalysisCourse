% For [0,20] I predict y deaths with x(t-Ο„) cases
% Compare and find best latency
% Diagnostic with standarised errror

% Kapoglis Konstantinos 9433
% Skapetis Christos 9378

alpha = 0.05;
zcrit = norminv(1-alpha/2);

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
Se = zeros(20,N_countries);
Mse = zeros(20,N_countries);
R2 = zeros(20,N_countries);
adjR2 = zeros(20,N_countries);
maxId = zeros(1,N_countries);
maxadjR2 = zeros(N_countries, 1);
% N_countries = x; to see the visualization of residuals for the x first
% countries. WARNING.x*20 plots

for country = 1:N_countries
    % estarV = zeros(20,endWave(country)-startWave(country)+1); I do not
    % preallocate it because it changes size in every loop
    x_Country= startWave(country):1:endWave(country);
    x_Country_Extended = (startWave(country)-20):1:(endWave(country));
    wave1 = world(countryIDs(country), x_Country_Extended);
    wave1(isnan(wave1))=0;
    deaths1 = worldDeaths(countryIDs(country), x_Country);
    deaths1(isnan(deaths1))=0;
    N = length(wave1);
    wave= wave1;
    deaths = deaths1;
    n = endWave(country)-startWave(country);
    yV = deaths(1:n);
    for t = 1:20
        xV = wave(t:n+t-1);
        modelfun = @(b,xV)b(1)*xV(:)+b(2);
        beta0 = [1 1];
        mdl = fitnlm(xV, yV, modelfun,beta0);
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
        %-----------------------
        R2(t, country) = mdl.Rsquared.Ordinary;          % R2
        adjR2(t, country) = mdl.Rsquared.Adjusted;       % adjR2
        %-----------------------
        yhat = b(1)*xV(:)+b(2);
        k1 = 1;                                          % 1 is number of x
        eV = yV - yhat;
        se2 = (1/(n-(k1+1)))*(sum(eV.^2));
        se = sqrt(se2);                                  %d standard deviation of errors
        estarV = eV / se;
%         Uncomment this to see all plots        
%         figure((country-1)*20+t)
%         clf
%         stem(estarV); %visualise residuals
%         hold on
%         ax = axis;
%         plot([ax(1) ax(2)],zcrit*[1 1], 'r--')
%         plot([ax(1) ax(2)],-zcrit*[1 1], 'r--')        
%         figure(t)
%         scatter(xV, yV);
%         hold on
%         plot(xV, b(1)*xV(:)+b(2));
%         20*11 plots. DO NOT TRY IT!
    end
    [B, I] = max(adjR2(:, country));
    maxId(country) = I;
    fprintf('For country %s the optimal delay is t =  %1.0f days and its adjR2 is %1.4f\n',countryNames(country),maxId(country),B);
    maxadjR2(country) = B;
end



% we implemented diagnostic test only for the best cases since all the
% cases are 220 plots

%%Comments
% Fainete h prosarmogi na einai to idio kali se oles ti hres pou dokimases?
% No. Countries like Belgium and Italy have great adjustment. However, the vast
% majority of the countries including Norway and Austria are far from acceptable.

% In the vast majority of the countries diagnostic test indicates that the
% linear model is efficient for this prediction.

% The prediction of the daily deaths by the daily cases is possible in some
% cases with great accuracy. We consider that with another model it may be
% even more accurate.The linear model is highly inefficient in most of
% countries.

% In Task 5 the delay is [16, 14, 11, 8,  3,  15, 8,  20,  9, 14, 11,  6]
% In Task 4 the delay is [6,  1,  11, 14, 19, 7, 13 ,-18, 13,  8, 11, 12]
% In Task 3 the delay is [0,  23, 21, 22, 20, 31, 0, -30, 12,  0, -5, 18] for
% distribution and       [-2, -2, 16, 19, 18, 6,  27,  4,-21,  84,-1,  8] for data
% As we can see all tasks have significant differences 

% Problems faced:
% -Too many plots asked by Task 5