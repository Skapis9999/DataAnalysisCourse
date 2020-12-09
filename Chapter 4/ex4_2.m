% Chapter 4 Exercise 2
%clc
clearvars

sigmaL = 5;  % uncertainty for length
sigmaW = 5;  % uncertainty for width
l = 500;     % length
w = 300;     %width

sigma = sqrt(w^2*sigmaL^2 + l^2*sigmaW^2);  %sigma of area



lGraph = [1:700];
wGraph = sqrt(sigma^2 - lGraph.^2*sigmaW^2)/sigmaL;

figure(1)
clf
plot(lGraph,wGraph)

figure(2)
clf
sigmaF= @(L,W) sqrt(W^2*sigmaL^2 + L^2*sigmaW^2);
zhandle = fcontour(sigmaF)

% lGraph = [1:50:10001]';
% wGraph = [1:50:10001]';
% nlGraph = length(lGraph);
% areagridM = NaN*ones(nlGraph);
% for i=1:nlGraph
%     for j=1:nlGraph
%         areagridM(j,i) = sqrt(wgridV(j)^2*lsigma^2 + lgridV(i)^2*wsigma^2);
%     end
% end
% figure(2)
% clf
% surf(lgridV,wgridV,areagridM)

lgridV = [1:50:10001]';
wgridV = [1:50:10001]';
nlgrid = length(lgridV);
areagridM = NaN*ones(nlgrid);
for i=1:nlgrid
    for j=1:nlgrid
        areagridM(j,i) = sqrt(wgridV(j)^2*sigmaL^2 + lgridV(i)^2*sigmaW^2);
    end
end
figure(3)
clf
surf(lgridV,wgridV,areagridM)
