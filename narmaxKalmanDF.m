% Compensasão do erro estático com modelo preditivo
% NARMAX com filtro de Kalman em cascata com IRR
% otimizado por JADE. [Dataset Last]

clear; clc;
close all;

load( 'dados/LastDatasetWorkingData.mat' );
loadutils( 'narmax' );
loadutils( 'opt' );
loadutils( 'progress' );

E = z - y;

model = narmax(E, [u1, u2]);
ML = 24;
model = frols(model, [0 ML ML 2], [10 1], 100);
generatesimfunc(model, 'estmodel', 1);
Ep = estmodel([u1, u2], E(1:ML), 0);

figure;
plot(E); hold on;
plot(Ep);
legend('Original', 'Predicted');

r = E - Ep;

figure;
plot(r);

w = y + Ep;
figure;
plot([y, w, z]);
legend('Original', 'Compensated', 'Reference');

% param = [0, 0.2, 100, 0, 0.2, 100];
% param = [4.3561e-10 29.7287 8.9604e+03 6.2631e-13 7.9014 9.2165e+03 0.9];
% param = [0 938.7163  592.2944 0 3.2575 952.5425 0.9416];
vlb = [0 0 0 0 0 0 0];
vub = [1000 1000 1000 1000 1000 1000 0.99];
if 1
    Problem = problem([], @(x) kalmanFobj(x, [w, DZ], k1, k2, k3, dt), 7, vlb, vub, true); 
    JADE = jade;
    JADE.PopSize = 50;
    JADE.MaxGenerations = 500;
    JADE.RefreshRate = 1;
    Problem.Optimize(JADE);
end

param = Problem.Xopt;

f = kalman1d(w, param(1:3));
figure;
plot([z, f]);

F = ohm2corr(f, k1, k2, k3);
DF = [0; diff(F)] * dt;
K = kalman1d(DF, param(4:end));
K = iir_filter(K, param(7));

Ref = fir_filter(Y, ones(48,1));
DRef = fir_filter([0; diff(Ref)] * dt, ones(48,1));

figure;
plot([K, DZ]); hold on;
plot(100:length(Ref), DRef(100:end));
