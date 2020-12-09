%rails of length X~N(4, 0.01). X < 3.9 rejeected.

mu = 4;
sigmasq = 0.01;
sigma = sqrt(sigmasq);


p = normcdf([-inf,3.9],mu,sigma); %Compute the probability that 
                                  %an observation from  X~N(4, 0.01)
                                  %distribution falls on the interval [-inf,3.9]. 
p(2)- p(1)                        %probability for a rail to be destroyed

%we could use normcdf(3.9,mu,sigma)

i = norminv(0.01,mu,sigma)      %new threshold limit in order to destroy up
                                %to 1% of the rails