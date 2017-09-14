clear all;
clc;
close all;

addpath models;
load datasetctg2_cdms_medio.mat;

data = data(1:10:end, :);            % Reamostra os dados
%data = data(data(:,28) > 50, :);    % Seleciona faixa de opera��o
%data(1060:1200,:) = [];             % Exclui momento do tunning
data(:, [26 27]) = [];               % Descarta vari�veis redundantes
header([21 26 27]) = [];             % Descarta tamb�m do cabe�alho          

Output = data(:,22);
Input = [data(:,1:21) data(:,23:end)];
nmodel = narmax(Output, Input, 'NOx', header);

nmodel.EstimationConfigurations.MaxLength = round(length(Output)/2);
nmodel.EstimationConfigurations.MinDiff = 0;

maxlag = 4;
ny = maxlag;
nu = maxlag;
ne = 4;
nl = 2;

nterms = [10 1];
iterations = 200;

%nmodel.CustomTerms = {'cos(y1(k-1))', 'cos(y1(k-2))', 'cos(y1(k-3))', 'cos(y1(k-4))', 'cos(y1(k-5))'};
%nmodel.CustomFunctions = {{ 'cos', @(x) cos(2*x*pi/180) }};

[nmodel, results, theta] = frols(nmodel, [ny nu ne nl], nterms, iterations);
for i = 1:1
    plot_xcorrel(results.E, nmodel.Data.SystemInputs(:,i));
    title(header(i));
end

figure;
plot(results.E, 'k');

figure;
randregion = randi(30000, 1);
bvec = 1:10000 + randregion;
y0 = nmodel.Data.SystemOutput(1:maxlag);

generatesimfunc(nmodel, 'modeloNOx', 1);
pause(0.1);
tic

Ys = modeloNOx(nmodel.Data.SystemInputs, y0, 0);
toc
T = 1:length(Ys);
plot(T, nmodel.Data.SystemOutput, T, Ys);
ylim([0 100]);
