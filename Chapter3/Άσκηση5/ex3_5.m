
%clf
alpha = 0.05;   %95%
var1 = 10;
var2 = 1;
m1 = 75;
m2 = 2.5;


%eruption(:,1);   that way you get a collumn
er_1 =table2array(eruption(:,1));
er_2 =table2array(eruption(:,2));
er_3 =table2array(eruption(:,3));

[h1,p1,ci1,stats1] = vartest(er_1, var1^2, alpha);
[h2,p2,ci2,stats2] = vartest(er_2, var2^2, alpha);
[h3,p3,ci3,stats3] = vartest(er_3, var1^2, alpha);

if(h1==0)
    fprintf('Yes in 1989 waiting time variance was %1.3f\n', var1);
else
    fprintf('No in 1989 waiting time variance was not %1.3f\n', var1');
end

if(h2==0)
    fprintf('Yes in 1989 duration variance was %1.3f\n', var2);
else
    fprintf('No in 1989 duration variance was not %1.3f\n', var2');
end

if(h3==0)
    fprintf('Yes in 2006 waiting time variance was %1.3f\n', var1);
else
    fprintf('No in 2006 waiting time variance was not %1.3f\n', var1');
end


[h1,p1,ci1,stats1] = ttest(er_1, m1^2, alpha);
[h2,p2,ci2,stats2] = ttest(er_2, m2^2, alpha);
[h3,p3,ci3,stats3] = ttest(er_3, m1^2, alpha);

if(h1==0)
    fprintf('Yes in 1989 waiting time variance was %1.3f\n', m1);
else
    fprintf('No in 1989 waiting time variance was not %1.3f\n', m1);
end

if(h2==0)
    fprintf('Yes in 1989 duration variance was %1.3f\n', m2);
else
    fprintf('No in 1989 duration variance was not %1.3f\n', m2);
end

if(h3==0)
    fprintf('Yes in 2006 waiting time variance was %1.3f\n', m1);
else
    fprintf('No in 2006 waiting time variance was not %1.3f\n', m1);
end

[h4, p4] = chi2gof(er_1);
[h5, p5] = chi2gof(er_2);
[h6, p6] = chi2gof(er_3);

fprintf('Ps are %1.15f, %1.80f and %1.15f \n', p4, p5, p6);

