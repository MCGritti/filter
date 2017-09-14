clear all;
clc;
close all;

addpath models;
load estimacao.mat;
nmodel = narmax(Angle, Power, 'Angle', 1, 'Power');

nmodel.EstimationConfigurations.MaxLength = round(length(Angle)/2);
nmodel.EstimationConfigurations.MinDiff = 0;

ny = 8;
nu = 10;
ne = 6;
nl = 3;
nterms = [8 2];
iterations = 1000;

nmodel.CustomTerms = {'cos(y1(k-1))', 'cos(y1(k-2))', 'cos(y1(k-3))', 'cos(y1(k-4))', 'cos(y1(k-5))'};
nmodel.CustomFunctions = {{ 'cos', @(x) cos(2*x*pi/180) }};

[nmodel, results, theta] = frols(nmodel, [ny nu ne nl], nterms, iterations);
plot_xcorrel(results.E, results.U);

figure;
plot(results.E, 'k');

generatesimfunc(nmodel, 'fanplatemodel', true);
Ys = fanplatemodel(nmodel.Data.SystemInputs, 0, 0);
figure;
plot(T, Angle, T, Ys);
% 
% load validacao.mat;
% Ys = simulatenarmax(nmodel, Power', [], 0);
% T = Idx';
% figure;
% plot(T, Angle', T, Ys);

