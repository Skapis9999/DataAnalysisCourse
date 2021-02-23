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
countryNames = ["Belgium", "UK", "Ireland", "Germany",...
    "Norway", "Italy", "Austria", "Sweden",...
    "Switzerland", "Spain", "Slovakia", "Slovenia"];

startWave = [60, 60, 65, 60, 58, 58, 64, 64, 50, 60, 66, 68];
endWave = [180, 200, 176, 150, 178, 170, 123, 139, 244, 142, 105, 117];

bestBetas = [-12.4085474226198,-0.00814803722236901,0,0,0,0,0,0,0,0,0,0,0.0259321512973131,0,0.0294162857797841,0.0327697312107613,0.0266246662061642,0.0381903697202992,0,0.0151621128251745,0.0210977422299825;-33.3724377242671,0,-0.0787586104343465,0,0,0,-0.0976312180158233,0.114529541111523,0,0,0,0.0935803029921673,-0.119158724537905,0,0.135828326843052,0.0478687484089178,0,0,0,0,0.0582752877841282;0.525331753952240,0,-0.0292734112316559,0,-0.0368501511679679,0.0630249697610096,0,0,0,0,0,0.0478992051935273,0,0,0.0436222366564558,-0.0397872205027113,0,-0.0251420631951587,0,0.0761317786698392,-0.0340932287886730;2.94404667921389,0.0177196768979892,0.0111262154098016,0,-0.0144440443602519,0,0,0,0.0125236866807486,0,0.0105089891179088,0,0,0,0,0.00993496559649680,0,0,0,0,0;-0.222135902759663,0.0109561650685864,0,0.0112105000432930,0,0,0,0,0,0,0,0,0,0,0,0,0.0100081520693313,0,0,0,0;12.0536369618786,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0.0756167727751346,0,0,0,0.0642447452508937,0;2.28484719941092,0,0,0.0145570295233570,0,0,0,0,0,0,0,0,0,0.0166679779538374,0,0,0,0,0,0,0;-0.406392077878016,0.0137538624403815,0.0291402589221089,0,-0.0300554852732724,0.0242610442302883,-0.0206523431166490,0,0,0,0,0,0,0,0,0.0214406303561609,0.0170197451908885,0,0,0,0;12.7120374684754,0,0,-0.0237940921467171,0,0,0,0,0,0,0,0,0,0,0,0,0,0.0369373407009343,0,0,0.0257780440936035;-8.17033854308767,0.0310458627394479,0,0,-0.0176201783569026,0,0,0,0,0,0,0,-0.0335138426560688,0.0565624951706449,0.0192341159628775,0,0,0.0274938962300704,0.0190202795554404,0.0227673295070405,0;0.0243811858161852,0,0,0,0.0101058082484320,0.0101654344553132,-0.00763844413133621,0,0,-0.00968502080903894,0,0.0225260270675758,0,0,0,0,-0.00432813243323333,-0.00803989417828421,0,0,0;-0.272679019761081,0,0,0,0,-0.0472498935437314,0.0801837583150202,0,0,0,0.0450202601768134,0,0,0,0,0,0,0,0,0,0];
%betas from Exe6
%beta0 = [-12.4085474226198;-33.3724377242671;0.525331753952240;2.94404667921389;-0.222135902759663;12.0536369618786;2.28484719941092;-0.406392077878016;12.7120374684754;-8.17033854308767;0.0243811858161852;-0.272679019761081];

N_countries = length(countryIDs);
start2 = zeros(N_countries);    %start of 2nd wave
end2 = zeros(N_countries);      %end of 2nd wave

for country = 1:N_countries
    rest = world(countryIDs(country), endWave(country):end);

for i = 1:N_countries
    rest = world(countryIDs(i), endWave(i):end);
N_countries = length(countryIDs);
start2 = zeros(N_countries);    %start of 2nd wave
end2 = zeros(N_countries);      %end of 2nd wave

for country = 1:N_countries
    rest = world(countryIDs(country), endWave(country):end);
>>>>>>> Stashed changes
>>>>>>> Stashed changes
    [startX,endX]=findwave(0.05, rest);                 %first orisma is acceptance percentage of the max in the same wave.
    start2(country)= startX + endWave(country);
    %fprintf("Gia thn xora %s to start2 %d kai to startX %d kai to endWave %d\n",countryNames(i),start2(i),startX,endWave(i))
    end2(country) = endX + endWave(country);
    %fprintf("Gia thn xora %s to end2 %d kai to endX %d kai to endWave %d\n",countryNames(i),end2(i),endX,endWave(i))
    figure(country)
    clf
    plot(world(countryIDs(country), 1:end))
    grid on;
    hold on
    line([start2(country),start2(country)], ylim, 'Color', 'k', 'LineWidth', 1); % Draw line for Y axis.
<<<<<<< Updated upstream
    hold on 
    line([end2(country),end2(country)], ylim, 'Color', 'k', 'LineWidth', 1); % Draw line for Y axis.
    %-------------------------------------------------------------------
    x_Country= (start2(country)-20):1:end2(country);
    sizeSecondWave = end2(country)-start2(country)+1;
    yhatV = NaN(sizeSecondWave);
    for predictionDate = 1:(end2(country)-start2(country)+1)
        
        xV = rest(predictionDate:20+predictionDate-1);
        xM = [1 xV];

%         xM =[xV, x_Country(predictionDate:(predictionDate+20))']
        yhatV(predictionDate) = xM* bestBetas(country,:)'
    end
    figure(N_countries+country)
    clf
    plot(yhatV)
    line([start2(country)-start2(country),start2(country)-start2(country)], ylim, 'Color', 'k', 'LineWidth', 1); % Draw line for Y axis.
    hold on 
=======
    hold on 
    line([end2(country),end2(country)], ylim, 'Color', 'k', 'LineWidth', 1); % Draw line for Y axis.
    %-------------------------------------------------------------------
    x_Country= (start2(country)-20):1:end2(country);
    sizeSecondWave = end2(country)-start2(country)+1;
    yhatV = NaN(sizeSecondWave);
    for predictionDate = 1:(end2(country)-start2(country)+1)
        
        xV = rest(predictionDate:20+predictionDate-1);
        xM = [1 xV];

%         xM =[xV, x_Country(predictionDate:(predictionDate+20))']
        yhatV(predictionDate) = xM* bestBetas(country,:)'
    end
    figure(N_countries+country)
    clf
    plot(yhatV)
    line([start2(country)-start2(country),start2(country)-start2(country)], ylim, 'Color', 'k', 'LineWidth', 1); % Draw line for Y axis.
    hold on 
>>>>>>> Stashed changes
    line([end2(country)-start2(country),end2(country)-start2(country)], ylim, 'Color', 'k', 'LineWidth', 1); % Draw line for Y axis.
    
end


%-------------------------------------------------------------------
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