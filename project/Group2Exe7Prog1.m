% Kapoglis Konstantinos 9433
% Skapetis Christos 9378
clear all
alpha = 0.05;
zcrit = norminv(1-alpha/2);
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

startWave = [63, 69, 72, 64, 62, 56, 68, 64, 64, 65, 70, 65];
endWave = [200, 200, 158, 200, 137, 172, 153, 200, 138, 185, 131, 135];
%betas from Exe6
bestBetas = [-13.6195003075017,-0.00742018464551680,0,0,0,0,0,0,0,0,0,0,0.0257267192001065,0,0.0292485817997774,0.0327606744811684,0.0266802961647394,0.0384865104196596,0,0.0152924026150748,0.0216026466408876;-40.5442073331888,0,-0.0769171658437564,0,0,0,-0.0980460864235275,0.114460728636993,0,0,0,0.0934129730560193,-0.119470600256199,0,0.135227352370023,0.0475346320004534,0,0,0,0,0.0606244715562509;-1.08885621297298,0,-0.0344017135876807,0,-0.0295673188598537,0.0701109606211736,0,0,0,0,0,0.0446227303833682,0,0,0,0,0,-0.0307466406730926,0,0.0506745215976366,0;-4.48008356902277,0.0185380317801155,0.0111694918815862,0,-0.0132991656469403,0,0,0,0.0109608529137398,0,0.0101990053740927,0,0,0,0,0.0119255691891614,0,0,0,0,0;0.287766613680900,0,0,0.0163789109815276,0,0,0,0,0,0,0.0110915212884014,0,0,0,0,0,0,0,0,0,0;11.8143175544071,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0.0756557489628967,0,0,0,0.0642726467119408,0;1.52651005490110,0,0,0,0,0,0.0155178677937824,0,0.00859940336897166,0,0,0,0,0,0,0,0,0,0.00900196875591418,0,0;35.8925991693166,0,0,0,0,0,-0.0255601675704376,0,0,0,0,0,0,0,0,0,0,0,0,0,0.0348790525496864;-0.420703725020500,0.0137617122409051,0.0291526708682091,0,-0.0300743680385309,0.0242650551201774,-0.0206517339343985,0,0,0,0,0,0,0,0,0.0214426303177790,0.0170327946232977,0,0,0,0;-2.85943083191664,0,0,0,0,0,0,0,0,0,0,0,0,0,0.0677656120823456,0,0,0.0479285849537202,0,0,0;-0.107717465380532,0,0,0,0,0,0,0,0,0,0,0.0119145990144975,0,0,0.0114197307379558,0,0,0,0,0,0;0.0194273996634447,0,0,0,0,-0.0308454688282734,0.0604813558252419,0,0,0,0.0419118792637688,0,0,0,0,0,0,0,0,0,0];
%beta0 = [-12.4085474226198;-33.3724377242671;0.525331753952240;2.94404667921389;-0.222135902759663;12.0536369618786;2.28484719941092;-0.406392077878016;12.7120374684754;-8.17033854308767;0.0243811858161852;-0.272679019761081];
ks = [8;8;6;6;2;2;3;2;7;2;2;3]; %number of acceptable betas per country
adjR2Real = [0.976337025540285;0.896443075822148;0.623054234648782;0.920980211476517;0.433425459108227;0.950976649195803;0.589875116942397;0.0805906456495319;0.754729523343698;0.573124788625315;0.322301677682662;0.553954356706783];

N_countries = length(countryIDs);
start2 = zeros(N_countries);    %start of 2nd wave
end2 = zeros(N_countries);      %end of 2nd wave
adjR2 = zeros(N_countries);
for country = 1:N_countries
    rest = world(countryIDs(country), endWave(country):end);
    [startX,endX]=findwave(0.05, rest);                 %first orisma is acceptance percentage of the max in the same wave.
    start2(country)= startX + endWave(country);
    end2(country) = endX + endWave(country);
    %figure indicating the limits of the second wave 
%     figure(country)
%     clf
%     plot(world(countryIDs(country), 1:end))
%     grid on;
%     hold on
%     line([start2(country),start2(country)], ylim, 'Color', 'k', 'LineWidth', 1); % Draw line for Y axis.
%     hold on 
%     line([end2(country),end2(country)], ylim, 'Color', 'k', 'LineWidth', 1); % Draw line for Y axis.
%     %-------------------------------------------------------------------
    sizeSecondWave = end2(country)-start2(country)+1;
    yhatV = NaN(sizeSecondWave,1);
    guessX = rest(startX-20:endX);
    for predictionDate = 1:1:sizeSecondWave
        
        xV = guessX(predictionDate:20+predictionDate-1);
        xM = [1 xV];
        yhatV(predictionDate) = xM* bestBetas(country,:)';
    end
    yV = worldDeaths(countryIDs(country),(start2(country))-1:end2(country)-1);
    n = length(yV);
    my = mean(yV);
    eV = yV'-yhatV;
    adjR2(country) = 1-((n-1)/(n-(ks(country)+1)))*(sum(eV.^2))/(sum((yV'-my).^2)); 
    
    figure(2*country-1)
    clf
    plot(yhatV)
    hold on
    plot(yV)
    hold on
    line([start2(country)-start2(country),start2(country)-start2(country)], ylim, 'Color', 'k', 'LineWidth', 1); % Draw line for Y axis.
    hold on 
    line([end2(country)-start2(country),end2(country)-start2(country)], ylim, 'Color', 'k', 'LineWidth', 1); % Draw line for Y axis.
    xlabel('deaths')
    ylabel('days of the second wave')
    title(sprintf('Deaths according to the model created in Exe6 and real deaths for country %s', countryNames(country))); 
    legend('yhat','y')
    
    se2 = (1/(n-(ks(country)+1)))*(sum(eV.^2));
    se = sqrt(se2);
    estarV = eV / se;
    figure(2*country)
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
    fprintf('For country %s the adjR2 for learning space is %1.4f while for judging space is %1.4f\n',countryNames(country), adjR2Real(country), adjR2(country));        
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

%For countries like Germany, Slovakia and Austria, our predictions were
%highly accurate. However, trying to predict deaths in countries like
%Belgium, the UK and Ireland was not that successful. adjR2 values were
%negative with high values.

%Normalised error is not considered the best way to judge our prediction
%since it indicates more if the yhat follows the shape of the real deaths
%data. That is the reason why adjusted R^2 was used for the comparison.

%Some suggestions about how our prediction would be better.
%1. Instead of using the trained model of the last wave it is advisable
%that the model is renewed every week. Utilizing the deaths of the previous
%days we would create a new model with new coefficients.
%2. It is observed that in most of cases the predicted plot used to follow
%the shape of the real plot. Without even changing our model we could add
%every day the error of the previous day.