% Compensasão do erro estático com modelo preditivo
% NARMAX com filtro IIR otimizado por JADE. [Dataset Last]

clear; clc;
close all;

load('dados/LastDatasetWorkingData.mat');
loadutils('narmax');
loadutils('opt');
loadutils('progress');


y = diffThreshold(y, 4e-4);

DZ = makeReference(DZ, 1, 2);
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

% w = y + Ep;
w = y;
dw = [0; diff(w)] * dt;
figure;
plot([y, w, z]);
legend('Original', 'Compensated', 'Reference');

param = [];

DIM = 4;
vlb = -2 * ones(1,DIM);
vub =  2 * ones(1,DIM);

P1 = problem([], @(x) iir_free_filter_fobj_mex(x, w, z), DIM, vlb, vub, true); 
P1.UseInitialGuess = 0;
OPT = jade;
OPT.PopSize = 200;
OPT.MaxGenerations = 500;
OPT.RefreshRate = 5;
P1.Optimize(OPT);
param1 = P1.Xopt;

f = iir_free_filter(w, param1);
figure;
plot([z, f, y]);

F = ohm2corr(f, k1, k2, k3);
DF = [0; diff(F)] * dt;

P2 = problem(param1, @(x) iir_free_filter_fobj_mex(x, DF, DZ), DIM, vlb, vub, true);
P2.UseInitialGuess = 1;
P2.Optimize(OPT);
param2 = P2.Xopt;

D = iir_free_filter(DF, param2);

Ref = fir_filter(Y, ones(48,1));
DRef = fir_filter([0; diff(Ref)] * dt, ones(48,1));

figure;
plot([D, DZ]); hold on;
plot(100:length(Ref), DRef(100:end));