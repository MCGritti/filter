clear; clc;
close all;

load('dados/FirstDatasetWorkingData.mat');

u1 = data(:,1);
u2 = data(:,2);
y  = data(:,3);

taxa_corr = zeros(size(y));
offset = 0;
taxa_corr(525:809+offset) = -0.279648606;
taxa_corr(981:1248+offset) = -0.171166593;

[Z, IZ] = corr2ohm(taxa_corr);

windowSize = 200;
smooth = cels_filter(y, windowSize, 0.98);
[Y, DY] = ohm2corr(smooth);

figure;
plot(taxa_corr(windowSize+2:end-windowSize-1)); hold on;
plot(DY(windowSize+2:end-windowSize-1));
legend('Taxa real', 'Smoothing');

err = IZ - y;
figure;
plot(err);

L = u1 - u2;
E = (err - min(err)) / (max(err) - min(err)) * 2 - 1;
P = (L - min(L)) / (max(L) - min(L)) * 2 - 1;

filterCoeff = 0.8;
plot([iir_filter(E(2:end),filterCoeff) ,iir_filter(P(2:end),filterCoeff)]);