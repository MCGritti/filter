% Compensasão do erro estático com modelo preditivo
% NARMAX com filtro não linear [Dataset Last]

clear; clc;
close all;

load('dados/LastDatasetWorkingData.mat');
loadutils('narmax');
loadutils('opt');
loadutils('progress');

y = diffThreshold(y, 4e-4);

DZ = makeReference(DZ, 1, 5);
Z = cumsum(DZ) / dt + e0;
z = corr2ohm(Z, k1, k2, k3);
dz = [0; diff(z)] * dt;

E = z - y;

model = narmax(E, [u1, u2]);
ML = 24;
model = frols(model, [0 ML ML 2], [15 0], 100);
generatesimfunc(model, 'estmodel', 1);
Ep = estmodel([u1, u2], E(1:ML), 0);

figure;
plot(E); hold on;
plot(Ep);
legend('Original', 'Predicted');

r = E - Ep;

figure;
plot(r);

w = y;
dw = [0; diff(w)] * dt;
figure;
plot([y, w, z]);
legend('Original', 'Compensated', 'Reference');

DIM = 8;
vlb = -1 * ones(1,DIM);
vub =  1 * ones(1,DIM);
OPT = jade;
OPT.PopSize = 200;
OPT.MaxGenerations = 400;
OPT.RefreshRate = 5;

Lag = 4;
close all;
firstFilter = narmax(z + 0.0001*randn(size(z)), w);
firstFilter.EstimationConfigurations.MaxLength = 100000;
firstFilter = frols(firstFilter, [Lag Lag 0 2], [6 0], 100);
generatesimfunc(firstFilter, 'first_filter', 1);
f = first_filter(w, z(1:100), 0);

figure;
plot([f, z, y]); hold on;
% plot(100:length(Ref), DRef(100:end));

F = ohm2corr(f, k1, k2, k3);
DF = [0; diff(F)] * dt;

secFilter = narmax(DZ, DF);
secFilter.EstimationConfigurations.MaxLength = 100000;
secFilter = frols(secFilter, [12 12 0 2], [12 0], 100);
generatesimfunc(secFilter, 'sec_filter', 1);
D = sec_filter(DF, DZ(1:100), 0);

Ref = fir_filter(Y, ones(48,1));
DRef = fir_filter([0; diff(Ref)] * dt, ones(48,1));

figure;
plot([D, DZ]); hold on;
plot(100:length(Ref), DRef(100:end));