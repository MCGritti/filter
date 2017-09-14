clear; clc;
close all;

load('dados/FirstDatasetWorkingData.mat');
loadutils('narmax');

u1 = data(:,1);
u2 = data(:,2);
y  = data(:,3);
dy = [0; diff(y)];
du1 = [0; diff(u1)];
du2 = [0; diff(u2)];
ddu1 = [0; diff(du1)];
ddu2 = [0; diff(du2)];


u  = [u1, y];
taxa_corr = zeros(size(y));
offset = 40;
taxa_corr(525:809+offset) = -0.279648606;
taxa_corr(981:1248+offset) = -0.171166593;

c1 = 1.50e-2;
c2 = 0.45 * c1;
c3 = 6.800584169e-4;
c4 = 2.52 * 0.45;
c5 = 24 * 365;

k1 = c2;
k2 = c1 - c3 * c4;
k3 = c4;

ref_corr = 0.45 + cumsum(taxa_corr) / c5;
trans = @(x) k1 ./ (k2 - k3*x);
yt = trans(y);
ref_ohm = k2/k3 - k1 ./ (ref_corr * k3);

ny = 0;
nu = 10;
ne = 10;
nl = 2;

model = narmax(ref_ohm(1:end-1), u(2:end,:));
model = frols(model, [ny nu ne nl], [15 1], 100);
generatesimfunc(model, 'narmaxFilter', 1);
yp = narmaxFilter(u, ref_ohm(1:nu), 0);
filtered = iir_filter(yp, [0.2 0.2 0.2]);
filtered = els_filter(filtered, 200, 0.95);

figure;
plot([ref_ohm, yp, y, filtered]);

figure;
plot([taxa_corr, c5 * [0;diff(k1 ./ (k2 - k3*filtered))]]);
