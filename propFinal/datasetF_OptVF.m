% Compensasão do erro estático com modelo preditivo
% NARMAX com filtro não linear [Dataset Final]

clear; clc;
close all;

load('dados/LastDatasetWorkingData.mat');
loadutils('narmax');
loadutils('opt');
loadutils('progress');

y = diffThreshold(y, 4e-4);

End = DZ(end);
DZ(DZ == End) = -0.5;

DZ = makeReference(DZ, 1, 5);
Z = cumsum(DZ) / dt + e0;
z = corr2ohm(Z, k1, k2, k3);
dz = [0; diff(z)] * dt;

w = y;
dw = [0; diff(w)] * dt;
figure;
plot([y, w, z]);
legend('Original', 'Compensated', 'Reference');

close all;

Lags = 120;
sOneTerms = 80;
sTwoTerms = 80;
sOneOrder = 1;
sTwoOrder = 1;

f = w;

figure;
plot([f, z, y]);

F = ohm2corr(f, k1, k2, k3);
DF = [0; diff(F)] * dt;

sTwo = narmax(DZ, DF);
sTwo.EstimationConfigurations.MaxLength = round( length(w) * 0.7 );
sTwo.EstimationConfigurations.Randomly = 0;
sTwo = frols(sTwo, [0 Lags 0 sTwoOrder], [sTwoTerms 0], 100);
generatesimfunc(sTwo, 'sTwoFilter', 1);

D = sTwoFilter(DF, DF(1:Lags+1), 0);

Ref = fir_filter(Y, ones(48,1));
DRef = fir_filter([0; diff(Ref)] * dt, ones(48,1));

figure;
plot(DZ); hold on;
plot(Lags+2:length(D), D(Lags+2:end));
plot(100:length(Ref), DRef(100:end));