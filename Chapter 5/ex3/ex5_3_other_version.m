% r=table2array(rain(1:39,1:12));
% t=table2array(temp(1:39,1:12));


datdir = 'E:\Έγγραφα2\Σπουδές\7ο Εξάμηνο\Ανάλυση Δεδομένων\Ανάλυση ασκήσεις\Chapter 5\ex3\';
dat1txt = 'rain';
dat2txt = 'temp';

r = load([datdir,dat1txt,'.dat']);
t = load([datdir,dat2txt,'.dat']);


alpha = 0.05;

cor = NaN(2,2);
R = NaN(1,12);
for month = 1:12
    cor = corrcoef(r(:,month),t(:,month));
    R(month) = cor(1,2);
end

%fprintf('Correlation is = %1.4f  \n',R);
plot(R);

figure(1)
clf
grid on;
plot(R);
hold on
% ax = axis;
% plot([1,1],[ax(3) ax(4)],'r')
line(xlim, [0,0], 'Color', 'k', 'LineWidth', 1); % Draw line for Y axis.
title(sprintf('Correlation of every month'));



L = 1000;       %number of permutations
nbins = 50;     %bins


R_1 = NaN(L, 12);
rand_R = NaN(39, 1);
%rand_T = NaN(20, 1);
v = NaN(39, 1);
for random_perm = 1:L
    for months = 1:12
        v(:)= randperm(39);
        %fprintf('%1.4f ', v);
        rand_R(:,1) = r(v(:), months);
        cor2 = corrcoef(rand_R, t(:,months));
        R_1(random_perm,months) = cor2(1,2);
    end
end

%R_1
t0 = NaN(1,12);
t0 = R .* sqrt (37./(1-R.^2));
t1= NaN(L,12);
t1 = R_1 .* sqrt (37./(1-R_1.^2));
%sortedT1=sort(t1);

sortedT1 = NaN(L,12);
for months = 1:12
    sortedT1(:,months)=sort(t1(:,months));
end

lowlim = round((alpha/2)*L);
upplim = round((1-alpha/2)*L);

tl = NaN(1,12);
tu = NaN(1,12);
tl(:) = sortedT1(lowlim,:); 
tu(:) = sortedT1(upplim,:);

for months = 1:12
    figure(months+1)
    histogram(sortedT1(:,months), nbins)
    hold on
    ax = axis;
    plot(tl(months)*[1 1],[ax(3) ax(4)],'r')
    plot(tu(months)*[1 1],[ax(3) ax(4)],'r')
    plot(t0(months)*[1 1],[ax(3) ax(4)],'b')
    title(sprintf('Month = %d', months));
end
