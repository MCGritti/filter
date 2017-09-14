clear all;
clc;
close all;

N = 2000;
e = 0.2*randn(N,1);
y = zeros(N,1);
u = 2*rand(N,1) - 1;

y(2) = -0.605*y(1) + 0.588*u(1) + e(2);
for k = 3:N
    y(k) = -0.605*y(k-1) - 0.163*y(k-2)^2 + 0.588*u(k-1) - 0.240*u(k-2) - 0.4*e(k-1) + e(k);
end

E = zeros(N, 1);
P = [y(2:end-1) y(1:end-2).^2 u(2:end-1) u(1:end-2) E(2:end-1)];
T = y(3:end);

theta = pinv(P)*T;
E = [0;0; T - P(:,1:4)*theta(1:4)];

for k = 1:10
    P = [y(2:end-1) y(1:end-2).^2 u(2:end-1) u(1:end-2) E(2:end-1)];
    theta = pinv(P)*T;
    E = [0;0; T - P*theta];
end

thetaELS = theta;
nmodel = narmax(y, u);
ny = 2;
nu = 2;
ne = 2;
nl = 2;
nterms = [4 1];
iter = 500;

[nmodel, results, theta] = frols(nmodel, [ny nu ne nl], nterms, iter);
generatesimfunc(nmodel, 'modeltest', 1)
Ys = modeltest(u, 0, 0);
t = 1:N;
plot(t, y, t, Ys); title('Simulação Livre');
figure; plot(t, e, t, results.E); title('Resíduos');
[var(e) var(results.E)]

{nmodel.ProcessTerms{:} nmodel.NoiseRelatedTerms{:}}'
thetaRLS = [theta; nmodel.NoiseTheta]
thetaELS