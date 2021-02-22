%For [0,20] I predict y deaths with x(t-Ο„) cases
%Compare and find best latency
%Diagnostic with standarised errror
%
% Kapoglis Konstantinos 9433
% Skapetis Christos 9378
clear all
alpha = 0.05;
zcrit = norminv(1-alpha/2);

world = table2array(readtable('Covid19Confirmed.xlsx','Range','D1:MM157'));
worldDeaths = table2array(readtable('Covid19Deaths.xlsx','Range','D1:MM157'));
j = 0;
if(world(1,1) < 43830)   %43831 is the first date
    j = -1;
end

countryIDs = [14+j, 148+j, 66+j, 53+j, 104+j, 68+j, 9+j,...
    135+j, 134+j, 131+j, 125+j, 126+j];
countryNames = ["Belgium", "UK", "Ireland", "Germany", "Norway", "Italy", "Austria", "Sweden",...
    "Switzerland", "Spain", "Slovakia", "Slovenia"];

startWave = [60, 60, 65, 60, 58, 58, 64, 64, 50, 60, 66, 68];
endWave = [180, 200, 176, 150, 178, 170, 123, 139, 244, 142, 105, 117];
N_countries = length(countryIDs);
adjR2 = zeros(N_countries, 1);
adjR2_all = zeros(N_countries, 1);
adjR2Exe5 = [0.795969995211820;0.760357428783247;0.435957817392143;0.822384144098678;0.449395432127319;0.906569851640084;0.492221802806972;0.533484292805293;0.166566277312669;0.840083471088131;0.369445584788788;0.469638686681325]
Model = zeros(N_countries, 20);

for country = 1:N_countries
    %estarV = zeros(20,endWave(country)-startWave(country)+1); I do not
    %preallocate it because it changes size in every loop
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
    xM = ones(n,1);
    for t = 1:20
        xV = wave(t:n+t-1);
        xM = [xM xV'];
    end
    my = mean(yV);
    k = size(xM,2);
    n = length(yV);
    zcrit = norminv(1-alpha/2);
    [bV,~,~,inmodel,stats]=stepwisefit(xM(:, 2:end), yV');
    b0 = stats.intercept;
    indxV = find(inmodel==1);
    Model(country, :) = inmodel;
    rem = ([b0;bV].*[1 inmodel]');
    yhatV = xM * rem;
    eV = yV'-yhatV;
    k1 = sum(inmodel);
    se2 = (1/(n-(k1+1)))*(sum(eV.^2));
    se = sqrt(se2);
    R2 = 1-(sum(eV.^2))/(sum((yV-my).^2));
    adjR2(country) =1-((n-1)/(n-(k1+1)))*(sum(eV.^2))/(sum((yV'-my).^2));
    estarV = eV / se;
    figure(country*2 -1)
    clf
    plot(yV,estarV,'o')
    hold on
    ax = axis;
    plot([ax(1) ax(2)],[0 0],'k')
    plot([ax(1) ax(2)],zcrit*[1 1],'c--')
    plot([ax(1) ax(2)],-zcrit*[1 1],'c--')
    xlabel('y')
    ylabel('e^*')
    title(sprintf('diagnostic plot, model from stepwise regression,\n using... only %d delayed cases for country %s', k1, countryNames(country)));
    % -----------------------------
    yhatV_all = xM * [b0; bV];
    eV = yV'-yhatV;
    k_all = 21;
    se2_all = (1/(n-(k_all+1)))*(sum(eV.^2));
    se = sqrt(se2);
    R2 = 1-(sum(eV.^2))/(sum((yV-my).^2));
    adjR2_all(country) =1-((n-1)/(n-(k_all+1)))*(sum(eV.^2))/(sum((yV'-my).^2));
    estarV_all = eV / se;
    figure(country*2)
    clf
    plot(yV,estarV,'o')
    hold on
    ax = axis;
    plot([ax(1) ax(2)],[0 0],'k')
    plot([ax(1) ax(2)],zcrit*[1 1],'c--')
    plot([ax(1) ax(2)],-zcrit*[1 1],'c--')
    xlabel('y')
    ylabel('e^*')
    title(sprintf('diagnostic plot, model from stepwise regression,\n using all delayed cases for country %s', countryNames(country)));
    
end


for country = 1:N_countries
    if(adjR2(country)>adjR2Exe5(country))
            g=sprintf('%d ', find(Model(country,:)==1));
            fprintf('For country %s the stepwise regression model (with delays: %s) is more reliable (%1.4f) than the linear regression model of Exe5 (%1.4f)\n',countryNames(country), g, adjR2(country), adjR2Exe5(country));
    else
            fprintf('For country %s the linear regression model of Exe5 id more reliable(%1.4f) than the stepwise regression model (%1.4f)\n',countryNames(country), adjR2(country), adjR2Exe5(country));
    end    
end
fprintf("----------------------------------------------------------------------------------------------------------------------------------------------------------\n")
fprintf("##########################################################################################################################################################\n")
fprintf("----------------------------------------------------------------------------------------------------------------------------------------------------------\n")

for country = 1:N_countries
    if(adjR2(country)>adjR2_all(country))
            g=sprintf('%d ', find(Model(country,:)==1));
            fprintf('For country %s the stepwise regression model (with delays: %s) is more reliable (%1.4f) than the linear regression model using all variables (%1.4f)\n',countryNames(country), g, adjR2(country),adjR2_all(country));
    else
            fprintf('For country %s the linear regression model of Exe5 id more reliable(%1.4f) than the stepwise regression model using all variables (%1.4f)\n',countryNames(country), adjR2(country), adjR2_all(country));
    end    
end

% In half the cases the linear model with multiple variables has an
% adjusted R square ratio of at least 90% that shows a well adjusted
% model. On the other hand some countries have an adjusted R square ratio
% between 50-70% that shows a mediocre adjustment of the data to the model
% but in any case it is better than the simple linear regression model. 

% Additionally, the stepwisefit regression model that reduses the dimension 
% of the regression results in an optimization of the adjustment R square 
% factor in all  cases.

% We have also found the number of variables needed to describe the model
% after the stepwisefit procedure has been performed and they are in almost
% every case from 2 to 8 in population.

