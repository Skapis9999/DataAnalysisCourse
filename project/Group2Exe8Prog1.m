clear all
alpha = 0.05;
zcrit = norminv(1-alpha/2);
world = table2array(readtable('Covid19Confirmed.xlsx','Range','D1:MM157'));
worldDeaths = table2array(readtable('Covid19Deaths.xlsx','Range','D1:MM157'));
world(isnan(world))=0;
worldDeaths(isnan(worldDeaths))=0;
d = 5; % The dimension reduction.


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
startWave2 = [271;247;226;265;292;275;258;279;285;235;268;274];
endWave2 = [349;349;349;349;349;349;349;348;349;348;349;349];
%betas from Exe6
bestBetas = [-13.6195003075017,-0.00742018464551680,0,0,0,0,0,0,0,0,0,0,0.0257267192001065,0,0.0292485817997774,0.0327606744811684,0.0266802961647394,0.0384865104196596,0,0.0152924026150748,0.0216026466408876;-40.5442073331888,0,-0.0769171658437564,0,0,0,-0.0980460864235275,0.114460728636993,0,0,0,0.0934129730560193,-0.119470600256199,0,0.135227352370023,0.0475346320004534,0,0,0,0,0.0606244715562509;-1.08885621297298,0,-0.0344017135876807,0,-0.0295673188598537,0.0701109606211736,0,0,0,0,0,0.0446227303833682,0,0,0,0,0,-0.0307466406730926,0,0.0506745215976366,0;-4.48008356902277,0.0185380317801155,0.0111694918815862,0,-0.0132991656469403,0,0,0,0.0109608529137398,0,0.0101990053740927,0,0,0,0,0.0119255691891614,0,0,0,0,0;0.287766613680900,0,0,0.0163789109815276,0,0,0,0,0,0,0.0110915212884014,0,0,0,0,0,0,0,0,0,0;11.8143175544071,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0.0756557489628967,0,0,0,0.0642726467119408,0;1.52651005490110,0,0,0,0,0,0.0155178677937824,0,0.00859940336897166,0,0,0,0,0,0,0,0,0,0.00900196875591418,0,0;35.8925991693166,0,0,0,0,0,-0.0255601675704376,0,0,0,0,0,0,0,0,0,0,0,0,0,0.0348790525496864;-0.420703725020500,0.0137617122409051,0.0291526708682091,0,-0.0300743680385309,0.0242650551201774,-0.0206517339343985,0,0,0,0,0,0,0,0,0.0214426303177790,0.0170327946232977,0,0,0,0;-2.85943083191664,0,0,0,0,0,0,0,0,0,0,0,0,0,0.0677656120823456,0,0,0.0479285849537202,0,0,0;-0.107717465380532,0,0,0,0,0,0,0,0,0,0,0.0119145990144975,0,0,0.0114197307379558,0,0,0,0,0,0;0.0194273996634447,0,0,0,0,-0.0308454688282734,0.0604813558252419,0,0,0,0.0419118792637688,0,0,0,0,0,0,0,0,0,0];
%beta0 = [-12.4085474226198;-33.3724377242671;0.525331753952240;2.94404667921389;-0.222135902759663;12.0536369618786;2.28484719941092;-0.406392077878016;12.7120374684754;-8.17033854308767;0.0243811858161852;-0.272679019761081];
ks = [8;8;6;6;2;2;3;2;7;2;2;3]; %number of acceptable betas per country
adjR2Real = [0.976337025540285;0.896443075822148;0.623054234648782;0.920980211476517;0.433425459108227;0.950976649195803;0.589875116942397;0.0805906456495319;0.754729523343698;0.573124788625315;0.322301677682662;0.553954356706783];
N_countries = length(countryIDs);
R2PCR = NaN(1,length(countryIDs));
adjR2PCR = NaN(1,length(countryIDs));
adjR2Predict_8 = NaN(1,length(countryIDs));
adjR2Predict_7 = [-437.440251702701;-154.595725133057;-84.4148697328710;-5.37196561007147;-11.3776151429437;-90.6100760224560;-1.62584886952177;-15.2231663154823;-43.7330458351414;-57.7638563643036;-2.13456064247291;-10.6406427781884];               

for country = 1:N_countries
    %SVD
    %----------------------------------------------------
    x_Country= startWave(country):1:endWave(country);
    x_Country_Extended = (startWave(country)-20):1:(endWave(country));
    wave1 = world(countryIDs(country), x_Country_Extended);
    wave1(isnan(wave1))=0;
    wave= wave1;
    yV = worldDeaths(countryIDs(country), x_Country);
    TSS = sum((yV-mean(yV)).^2);
    n = endWave(country)-startWave(country)+1;
    xM =[];
    for t = 1:20
        xV = wave(t:n+t-1);
        xM = [xM xV'];
    end
    %Centering the data
    mxV = mean(xM);
    xcM = xM - repmat(mxV,n,1); % centered data matrix
    my = mean(yV);
    ycV = yV - my;
    [uM,sigmaM,vM] = svd(xcM,'econ');
    % PCR 
    %------------------------------------------------------
    lambdaV = zeros(20,1);
    lambdaV(1:d) = 1;
    bPCRV = vM * diag(lambdaV) * inv(sigmaM) * uM'* ycV';
    bPCRV = [my - mxV*bPCRV; bPCRV];
    yfitPCRV = [ones(n,1) xM] * bPCRV; 
    resPCRV = yfitPCRV - yV';     % Calculate residuals
    RSSPCR = sum(resPCRV.^2);
    rsquaredPCR = 1 - RSSPCR/TSS;
    R2PCR(1,country) = rsquaredPCR;
    adjR2PCR(country) = 1- ((n-1)/(n-d-1))*RSSPCR/TSS;
    figure(2*country-1)
    clf
    plot(yV',yfitPCRV,'.')
    hold on
    xlabel('y')
    ylabel('$\hat{y}$','Interpreter','Latex')
    title(sprintf('PCR adjR^2=%1.4f',adjR2PCR(country)))
    figure(2*country)
    clf
    plot(yV,resPCRV/std(resPCRV),'.','Markersize',10)
    hold on
    plot(xlim,zcrit*[1 1],'--c')
    plot(xlim,-zcrit*[1 1],'--c')
    xlabel('y')
    ylabel('e^*')
    title('PCR')
    %-----------------------------------------------------
    rest = world(countryIDs(country), endWave(country):end);
    [startX,endX]=findwave(0.05, rest);
    sizeSecondWave = endWave2(country)-startWave2(country)+1;
    yhatV = NaN(sizeSecondWave,1);
    guessX = rest(startX-20:endX);
    for predictionDate = 1:1:sizeSecondWave     
        xV = guessX(predictionDate:20+predictionDate-1);
        xM = [1 xV];
        yhatV(predictionDate) = xM* bPCRV;
    end
    yV = worldDeaths(countryIDs(country),(startWave2(country))-1:endWave2(country)-1);
    n = length(yV);
    my = mean(yV);
    eV = yV'-yhatV;
    adjR2Predict_8(country) = 1-((n-1)/(n-(d+1)))*(sum(eV.^2))/(sum((yV'-my).^2)); 
end
fprintf('First wave fitting model evaluation \n')
fprintf('------------------------------------- \n')
for country = 1:N_countries
   if(adjR2PCR(country) > adjR2Real(country))
           fprintf('For country %s the adjR2 for PCR (%1.4f) is better than that of Stepwisefit  (%1.4f)\n',countryNames(country), adjR2PCR(country), adjR2Real(country));                 
   else
            fprintf('For country %s the adjR2 for Stepwisefit (%1.4f) is better than that of PCR  (%1.4f)\n',countryNames(country), adjR2Real(country), adjR2PCR(country));
   end      
end

fprintf('-------------------------------------\n')
fprintf('Second wave prediction model evaluation \n')
fprintf('-------------------------------------\n')
for country = 1:N_countries
   if(adjR2Predict_8(country) > adjR2Predict_7(country))
           fprintf('For country %s the adjR2 for PCR (%1.4f) is better than that of Stepwisefit  (%1.4f)\n',countryNames(country), adjR2Predict_8(country), adjR2Predict_7(country));                 
   else
            fprintf('For country %s the adjR2 for Stepwisefit (%1.4f) is better than that of PCR  (%1.4f)\n',countryNames(country), adjR2Predict_7(country), adjR2Predict_8(country));
   end      
end

% For some countries the PCR model is more well adjusted than the stepwise
% fit model and for some other countries the stepwise fit model is better
% (the adjusted R squared factor is better

% We observe that for some countries both of the models (PCR and stepwise
% fit) do not provide us a reliable prediction model as the adjR2 is a
% really low value (Belgium, UK, Ireland and Italy). 

% For the rest of the countries, in some cases the PCR method provides us with
% a more reliable model and in some of the others the Stepwise fit produses
% a more reliable prediction model.

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
