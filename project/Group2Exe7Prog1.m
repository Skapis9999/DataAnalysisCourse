% Kapoglis Konstantinos 9433
% Skapetis Christos 9378
clear all
world = table2array(readtable('Covid19Confirmed.xlsx','Range','D1:MM157'));
worldDeaths = table2array(readtable('Covid19Deaths.xlsx','Range','D1:MM157'));
j = 0;
if(world(1,1) < 43830)   %43831 is the first date
    j = -1;
end

countryIDs = [14+j, 148+j, 66+j, 53+j, 104+j, 68+j, 9+j,...
    134+j, 135+j, 131+j, 125+j, 126+j];
countryNames = ["Belgium", "UK", "Ireland", "Germany", "Norway", "Italy", "Austria", "Sweden",...
    "Switzerland", "Spain", "Slovakia", "Slovenia"];

startWave = [60, 60, 65, 60, 58, 58, 64, 64, 50, 60, 66, 68];
endWave = [180, 200, 176, 150, 178, 170, 123, 139, 244, 142, 105, 117];

N_countries = length(countryIDs);
bestModel = zeros(20,N_countries); %20 betas from best model for N_countries countries
maxid = zeros(N_countries);
l = size(world,2);
% for i = 1:N_countries
rest = world(countryIDs(7), endWave(7):end);
[M,I] = max(rest');
%for j = endWave(7):l
 mean7 = movmean(rest,3)
        
%% end
for i = 1:N_countries
    figure(i)
    plot(world(countryIDs(i), endWave(i):end))
    hold on
end

function [startwave, endwave] = findwave(percentage, cases)
    M = max(cases);
    mean7 = movmean(cases,3);
    startwave = find(mean7 < percentage * M);
    startwave = max(startwave);
    endwave = end;
end 