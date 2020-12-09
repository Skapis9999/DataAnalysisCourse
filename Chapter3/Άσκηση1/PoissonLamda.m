%(a) prove that lamda is η δειγματική μέση τιμή
%(b) 

clc
clear all
lamda = [10:5:100];
nn = length(lamda);

% for i = 1:nn
%     v(1:100000) = poissrnd(lamda(i));
%     mean(v);
%     fprintf('\n');
%     fprintf('for lamda = %2.0f mean = %2.00f \n',lamda(i),mean(v));
% end


lamda2 = 10;

for i = 1:1000
    u(1:100000) = poissrnd(lamda2);
    v(i) = mean(u);
end

mean(v)