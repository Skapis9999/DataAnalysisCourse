clc
clear
%clf
alpha = 0.05;   %95%
varV = 5; %5kV
m = 52;

%(a)(b)

values =[41 46 47 47 48 50 50 50 50 50 50 50 48 50 50 50 50 50 50 50 52 52 53 55 50 50 50 50 52 52 53 53 53 53 53 57 52 52 53 53 53 53 53 53 54 54 55 68];
hist(values);

[h,p,ci,stats] = vartest(values, varV^2, alpha);

%[ h is a test decision for the paired-sample t-test,
% p is 
% ci is limits 9.0484   20.4855

fprintf('Confidence interval of variance = [%1.3f, %1.3f]\n',ci(1), ci(2));


%s = std(values);
%fprintf('The standard deviation of the elements of values = %1.3f\n',stats.sd);
[h,p,ci,stats] = ttest(values, m, alpha);
if(h==0)
    fprintf('Yes it can\n');
else
    fprintf('No it cannot\n');
end


[h2, p2] = chi2gof(values);
if(h2==0)
    fprintf('Yes it can\n');
else
    fprintf('No it cannot\n');
end

p2