% Kapoglis Konstantinos 9433
% Skapetis Christos 9378
clear all
world = table2array(readtable('Covid19Confirmed.xlsx','Range','D1:MM157'));
worldDeaths = table2array(readtable('Covid19Deaths.xlsx','Range','D1:MM157'));
world(isnan(world))=0;
worldDeaths(isnan(worldDeaths))=0;

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
start2 = zeros(N_countries); 
end2 = zeros(N_countries);


for i = 1:N_countries
    rest = world(countryIDs(i), endWave(i):end);
    [startX,endX]=findwave(0.05, rest);                 %first orisma is acceptance percentage of the max in the same wave.
    start2(i)= startX + endWave(i);
    %fprintf("Gia thn xora %s to start2 %d kai to startX %d kai to endWave %d\n",countryNames(i),start2(i),startX,endWave(i))
    end2(i) = endX + endWave(i);
    %fprintf("Gia thn xora %s to end2 %d kai to endX %d kai to endWave %d\n",countryNames(i),end2(i),endX,endWave(i))
    figure(i)
    clf
    plot(world(countryIDs(i), 1:end))
    grid on;
    hold on
    line([start2(i),start2(i)], ylim, 'Color', 'k', 'LineWidth', 1); % Draw line for Y axis.
    hold on 
    line([end2(i),end2(i)], ylim, 'Color', 'k', 'LineWidth', 1); % Draw line for Y axis.
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
