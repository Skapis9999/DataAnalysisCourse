% Exercise 3 Chapter2
% Prove that Var[x+y]=Var[x]+Var[y] does not hold when X,Y are correlated.

n=10000;
sigma1 = 1;         %ó1
sigma2 = 1;         %ó2
rho = 0.8;          %ñ12
muV=[0 0];

sigma12 = rho * sigma1 * sigma2;
covvarM = [sigma1 sigma12; sigma12 sigma2];
R = mvnrnd(muV,covvarM,n);
varxy = var(R(:,1)+R(:,2));
varx = var(R(:,1));
vary = var(R(:,2));

fprintf('\n');
fprintf('Var[X+Y]=%3.3f  Var[X]+Var[Y]=%3.3f+%3.3f=%3.3f \n',varxy,varx,...
    vary,varx+vary);

Theoretical values (given Var[X]=1.000000, Var[Y]=1.000000, rho=0.800000): 
1. Var[X] + Var[Y] = 1.000000 + 1.000000 = 2.000000 
2. Var[X+Y]  = Var[X] + Var[Y] + 2*Cov(X,Y) 
   Var[X] + Var[Y] + 2*rho*sqrt(Var[X]Var[Y]) 
   1.000000 + 1.000000 + 2 x 0.800000 x 1.000000 x 1.000000 = 3.600000 