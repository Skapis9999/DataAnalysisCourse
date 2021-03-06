%% Kapoglis Konstantinos 9433
%% Skapetis Christos 9378

%% Bulgaria and Kosovo,
% the two countries we had to choose, had not two
% discrete waves so we decided to choose Belgium which is near Bulgaria
clear all

world = table2array(readtable('Covid19Confirmed.xlsx','Range','D1:MM157'));
worldDeaths = table2array(readtable('Covid19Deaths.xlsx','Range','D1:MM157'));
j = 0;
if(world(1,1) < 43830)   %43831 is the first date
    j = -1;
end
belgiumID=14+j;
pd_count = 17;

percentage = 0.02;
[Start End] = findwave(percentage, world(belgiumID, 1:200));

waveBelgium1 = world(belgiumID,Start:End);
DeathsBelgium1 = worldDeaths(belgiumID,Start:End);
N_Cases = sum(waveBelgium1);
N_Deaths = sum(DeathsBelgium1);
waveBelgium = waveBelgium1/N_Cases;
DeathsBelgium = DeathsBelgium1/N_Deaths;
N = length(waveBelgium1);

MSE_Cases = zeros(pd_count, 1);
MSE_Deaths = zeros(pd_count, 1);
pd = zeros(pd_count, N);
Dist_Names = strings(pd_count,1);


% we observe that the first day of the first wave is the 60th day with 18
% cases and the last day of the first wave is the 152nd day with 61 cases

figure(1)
clf
plot(world(belgiumID, Start:End))
x = 1:N;
xlabel('days')
ylabel('cases')
title(sprintf('Cases for Belgium during the pandemic first wave'))

[pd , Dist_Names] = AllDistributions(x, pd, Dist_Names);
for pdi = 1:pd_count
    figure(pdi+1)
    clf
    plot(x, pd(pdi, :), 'LineWidth',2)
    hold on
    plot(waveBelgium)
    xlabel('days')
    ylabel('probability distribution')
    title(sprintf('First wave of the pandemic for Belgium, \nDistribution %s', Dist_Names(pdi)))
    legend(Dist_Names(pdi), 'Belgium Case Distibution')
end

% Due to chi square test giving too small values, we decided to use the
% Least Square Error Method.

for pdi =  1:pd_count
    for sample = 1:N
        MSE_Cases(pdi) = MSE_Cases(pdi) + (waveBelgium(sample) - pd(pdi, sample))^2/N;
    end
end

[B, I] = sort(MSE_Cases);
fprintf('The MSE test for Cases has resulted in the following sorting of the distributions in ascneding order:\n')
Dist_Names(I);
 fprintf("MSE \t \t \t Distribution\n")
 fprintf("-------------------------------\n")
for i = 1:length(Dist_Names)
    fprintf("%s \t %s \n", MSE_Cases(I(i)), Dist_Names(I(i)))
end

figure(pd_count+2)
plot(DeathsBelgium/sum(DeathsBelgium))
xlabel('days')
ylabel('probability distribution of deaths')
title(sprintf('First wave of the pandemic for Belgium, distribution of deaths'))

for pdi =  1:pd_count
    for sample = 1:N
        MSE_Deaths(pdi) = MSE_Deaths(pdi) + (DeathsBelgium(sample) - pd(pdi, sample))^2/N;
    end
end
[B, I] = sort(MSE_Deaths);
Dist_Names(I);

fprintf('\nThe MSE test for Deaths has resulted in the following\nsorting of the distributions in ascneding order:\n')
Dist_Names(I);
 fprintf("MSE \t \t \t Distribution\n")
 fprintf("-------------------------------\n")
for i = 1:length(Dist_Names)
    fprintf("%s \t %s \n", MSE_Deaths(I(i)), Dist_Names(I(i)))
end
%% finding the optimal distribution
function [pd, Dist_Names] = AllDistributions(x, pd, Dist_Names)
    pd_model = fitdist((x)', 'Normal');
    Dist_Names(1, :) = pd_model.DistributionName;
    pd(1, :) = pdf(pd_model,x);

    pd_model = fitdist((x)', 'Rayleigh');
    Dist_Names(2, :) = pd_model.DistributionName;
    pd(2, :)=pdf(pd_model,x);

    pd_model = fitdist((x)', 'Poisson');
    Dist_Names(3, :) =  pd_model.DistributionName;
    pd(3, :)=pdf(pd_model,x);

    pd_model = fitdist((x)', 'Rician');
    Dist_Names(4, :) =  pd_model.DistributionName;
    pd(4, :)=pdf(pd_model,x);

    pd_model = fitdist((x)', 'Lognormal');
    Dist_Names(5, :) =  pd_model.DistributionName;
    pd(5, :)=pdf(pd_model, x);

    pd_model = fitdist((x)', 'BirnbaumSaunders');
    Dist_Names(6, :) =  pd_model.DistributionName;
    pd(6, :)=pdf(pd_model, x);

    pd_model = fitdist((x)', 'ExtremeValue');
    Dist_Names(7, :) =  pd_model.DistributionName;
    pd(7, :)=pdf(pd_model, x);

    pd_model = fitdist((x)', 'Gamma');
    Dist_Names(8, :) =  pd_model.DistributionName;
    pd(8, :)=pdf(pd_model, x);

    pd_model = fitdist((x)', 'GeneralizedExtremeValue');
    Dist_Names(9, :) =  pd_model.DistributionName;
    pd(9, :)=pdf(pd_model, x);

    pd_model = fitdist((x)', 'HalfNormal');
    Dist_Names(10, :) =  pd_model.DistributionName;
    pd(10, :)=pdf(pd_model, x);

    pd_model = fitdist((x)', 'InverseGaussian');
    Dist_Names(11, :) =  pd_model.DistributionName;
    pd(11, :)=pdf(pd_model, x);

    pd_model = fitdist((x)', 'Kernel');
    Dist_Names(12, :) =  pd_model.DistributionName;
    pd(12, :)=pdf(pd_model, x);

    pd_model = fitdist((x)', 'Logistic');
    pd(13, :)=pdf(pd_model, x);
    Dist_Names(13, :) =  pd_model.DistributionName;

    pd_model = fitdist((x)', 'Nakagami');
    pd(14, :)=pdf(pd_model, x);
    Dist_Names(14, :) =  pd_model.DistributionName;

    pd_model = fitdist((x)', 'NegativeBinomial');
    pd(15, :)=pdf(pd_model, x);
    Dist_Names(15, :) =  pd_model.DistributionName;

    pd_model = fitdist((x)', 'tLocationScale');
    pd(16, :)=pdf(pd_model, x);
    Dist_Names(16, :) =  pd_model.DistributionName;

    pd_model = fitdist((x)', 'Weibull');
    pd(17, :)=pdf(pd_model, x);
    Dist_Names(17, :) =  pd_model.DistributionName;

end
function [startwave, endwave] = findwave(percentage, cases)
    [M,I] = max(cases);
    mean7 = movmean(cases,3);       % second argument is how many days you count to confirm the end or the start of a wave
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
%% Comments

% We observe that for the Cases the minimum values for the Least Square Error
% is achieved for the Lognormal, while the Gamma, Negative Binomial
% Distribution and the Weibull distributions have simillar values.

% We note that for the Deaths the Least Square Error is achieved for the 
% Negative Binomial, although Gamma, Lognormal and Weibull have also 
% simillar values.


% As a result, cases and deaths do not follow the same distribution but the
% same distribution, for example Gamma, Lognormal, Negative Binomial and
% Weibull estimate both the cases and deaths with high accuracy.


