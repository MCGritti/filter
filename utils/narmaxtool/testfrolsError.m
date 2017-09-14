clear all;
clc;
close all;

iterations = 1000;

N = 250;
e = 0.04*randn(N,1);
y = zeros(N,1);
u = [1*randn(150,1);2*ones(N-150, 1)];

y(2) = 0.5*y(1) + 0.1*u(1) + 0.5*e(1) + e(2);
for k = 3:N
    y(k) = 0.5*y(k-1) + u(k-2) + 0.2*u(k-1)^2 + 0.5*e(k-1) + 0.8*u(k-1)*e(k-2) + e(k);
end
nmodel = narmax(y, u);
ny = 2;
nu = 2;
ne = 2;
nl = 2;
nterms = [3 2];

nmodel.EstimationConfigurations.MaxLength = 100;
[nmodel, results, theta] = frols(nmodel, [ny nu ne nl], nterms, iterations);
nmodel.ProcessTerms
nmodel.ProcessTheta
nmodel.NoiseRelatedTerms
nmodel.NoiseTheta

plot_xcorrel(results.E, u);

figure;
t = (1:N)';
plot(t, u, t, y)

Ys = simulatenarmax(nmodel, u, 0.01, false);

figure,
plot(t, y, t, Ys);