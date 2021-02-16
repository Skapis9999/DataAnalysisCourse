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
Start = 60;
End = 180;
pd_count = 17;

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


%we observe that the first day of the first wave is the 60th day with 18
%cases and the last day of the first wave is the 152nd day with 61 cases

figure(1)
clf
plot(waveBelgium1)
x = 1:N;

[pd , Dist_Names] = AllDistributions(x, pd, Dist_Names);
for pdi = 1:pd_count
    figure(pdi+1)
    clf
    plot(x, pd(pdi, :), 'LineWidth',2)
    hold on
    plot(waveBelgium)
end

% Due to chi square test giving too small values, we decided to use the
% Least Square Error Method.

for pdi =  1:pd_count
    for sample = 1:N
        MSE_Cases(pdi) = MSE_Cases(pdi) + (waveBelgium(sample) - pd(pdi, sample))^2/N;
    end
end

[B, I] = sort(MSE_Cases);

Dist_Names(I);
B;
 figure(pd_count+2)
 plot(DeathsBelgium/sum(DeathsBelgium))
 hold on

for pdi =  1:pd_count
    for sample = 1:N
        MSE_Deaths(pdi) = MSE_Deaths(pdi) + (DeathsBelgium(sample) - pd(pdi, sample))^2/N;
    end
end
[B, I] = sort(MSE_Deaths);
Dist_Names(I);
B;

%%finding the optimal distribution
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
    Dist_Names(6, :) =  pd_model.DistributionName;
    pd(7, :)=pdf(pd_model, x);

    pd_model = fitdist((x)', 'Gamma');
    Dist_Names(7, :) =  pd_model.DistributionName;
    pd(8, :)=pdf(pd_model, x);

    pd_model = fitdist((x)', 'GeneralizedExtremeValue');
    Dist_Names(8, :) =  pd_model.DistributionName;
    pd(9, :)=pdf(pd_model, x);

    pd_model = fitdist((x)', 'HalfNormal');
    Dist_Names(9, :) =  pd_model.DistributionName;
    pd(10, :)=pdf(pd_model, x);

    pd_model = fitdist((x)', 'InverseGaussian');
    Dist_Names(10, :) =  pd_model.DistributionName;
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

%% Comments

% We observe that for the Cases the minimum values for the Least Square Error
% is achieved for the Negative Binomial Distribution, while the General
% Extreme Value Distribution, the Weibull and Rayleigh distributions have
% simillar values.

% We note that for the Deaths the Least Square Error is achieved for the 
% Rayleigh distribution, although Rician, Weibull and Negative Binomial
% have also simillar values.


% As a result, cases and deaths do not follow the same distribution but the
% same distribution, for example Rayleigh, Weibull and negative Binomial
% estimate both the cases and deaths with high accuracy.


