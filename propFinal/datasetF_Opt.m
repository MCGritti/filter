% Compensasão do erro estático com modelo preditivo
% NARMAX com filtro não linear [Dataset Final]

clear; clc;
close all;

load('dados/UpdatedDatasetWorkingData.mat');
loadutils('narmax');
loadutils('opt');
loadutils('progress');

for i = 6:length(dy)
    P = -0.5776 * dy(i-1);
    r = (dy(i) - P);
    if r^2 > 0.3
        y(i) = mean(y(i-5:i-1));
    end
end
Y = ohm2corr(y, k1, k2, k3);
% y = diffThreshold(y, 4e-4);

DZ(DZ > -0.1) = 0;
DZ(DZ == DZ(333)) = -0.46;
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

Lags = 80;
sOneTerms = Lags;
sTwoTerms = Lags;
sOneOrder = 1;
sTwoOrder = 1;

sOne = narmax(z, w);
sOne.EstimationConfigurations.MaxLength = round( length(w) * 1 );
sOne.EstimationConfigurations.Randomly = 1;
sOne = frols(sOne, [0 Lags 0 sOneOrder], [sOneTerms 0], 100);
generatesimfunc(sOne, 'sOneFilter', 1);

f = sOneFilter(w, w(1:Lags+1), 0);

figure;
plot([f, z, y]);

F = ohm2corr(w, k1, k2, k3);
DF = [0; diff(F)] * dt;

sTwo = narmax(DZ, DF);
sTwo.EstimationConfigurations.MaxLength = round( length(w) * 1 );
sTwo.EstimationConfigurations.Randomly = 1;
sTwo = frols(sTwo, [0 Lags 0 sTwoOrder], [sTwoTerms 0], 100);
generatesimfunc(sTwo, 'sTwoFilter', 1);

D = sTwoFilter(DF, DF(1:Lags+1), 0);
DD = iir_filter(D, 0.94);

Ref = fir_filter(Y, ones(48,1));
DRef = fir_filter([0; diff(Ref)] * dt, ones(48,1));

figure;
plot(DZ); hold on;
plot(50:length(DD), DD(50:end));
plot(Lags+2:length(D), D(Lags+2:end));
plot(100:length(Ref), DRef(100:end));