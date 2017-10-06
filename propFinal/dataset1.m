% Compensasão do erro estático com modelo preditivo
% NARMAX com filtro não linear [Dataset 1]

clear; clc;
close all;

load('dados/FirstDatasetWorkingData.mat');
loadutils('narmax');
loadutils('opt');
loadutils('progress');

DZ = makeReference(DZ, 1, 30);
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

close all;
w = y + Ep;
dw = [0; diff(w)] * dt;
figure;
plot([y, w, z]);
legend('Original', 'Compensated', 'Reference');

close all;
Lags = 80;
Selector = repmat(Lags:length(w), Lags, 1)' - repmat(1:Lags, length(w)-Lags+1, 1) + 1;
Target = z(Lags:end);
X = [w(Selector) w(Selector).^2];
theta = pinv(X) * Target;

f = [w(1:Lags-1); X*theta];
figure;
plot([f, z, y]);

F = ohm2corr(f, k1, k2, k3);
DF = [0; diff(F)] * dt;

X = [DF(Selector) DF(Selector).^2];
Target = DZ(Lags:end);
beta = pinv(X) * Target;

D = [DZ(1:Lags-1); X*beta];

%D = fir_filter(DF, ones(48,1));

Ref = fir_filter(Y, ones(48,1));
DRef = fir_filter([0; diff(Ref)] * dt, ones(48,1));

figure;
plot(DZ); hold on;
plot(100:length(D), D(100:end));
plot(100:length(Ref), DRef(100:end));