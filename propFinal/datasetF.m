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
% y = diffThreshold(y, 4e-4);

DZ(DZ == DZ(333)) = -0.45;
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
Lags = 50;
Est = 1:206;
Order = 1;
Selector = repmat(Lags:length(w), Lags, 1)' - repmat(1:Lags, length(w)-Lags+1, 1) + 1;
Target = z(Lags:end);
X = [];
for i = 1:Order
    X = [X w(Selector).^i];
end
theta = pinv(X(Est,:)) * Target(Est);

f = [w(1:Lags-1); X*theta];
figure;
plot([f, z, y]);

F = ohm2corr(f, k1, k2, k3);
DF = [0; diff(F)] * dt;

X = [];
for i = 1:Order
    X = [X DF(Selector).^i];
end
Target = DZ(Lags:end);
beta = pinv(X(Est,:)) * Target(Est);

D = [DF(1:Lags-1); X*beta];

Ref = fir_filter(Y, ones(48,1));
DRef = fir_filter([0; diff(Ref)] * dt, ones(48,1));

figure;
plot(DZ); hold on;
plot(Lags+2:length(D), D(Lags+2:end));
plot(100:length(Ref), DRef(100:end));