clear all;
clc;
close all;
addpath models;

load vibracao.mat;
mancal1 = mancal(2);
mancal1.AbsPos = mancal1.Pos(:,1);
mancal1.AbsVel = mancal1.Vel(:,1);
%mancal1.AbsPos = 2*( mancal1.AbsPos - min(mancal1.AbsPos) ) / ( max(mancal1.AbsPos) - min(mancal1.AbsPos) );
%mancal1.AbsVel = 2*( mancal1.AbsVel - min(mancal1.AbsVel) ) / ( max(mancal1.AbsVel) - min(mancal1.AbsVel) );
%Power = 4*( Power - min(Power) ) / ( max(Power) - min(Power) ) - 1;
m1vib = narmax(mancal1.AbsPos, [Power mancal1.AbsVel], 'Posi��o Absoluta', 1, 'Pot�ncia', 2, 'Velocidade Absoluta');

gain = 1;
ny = 10*gain;
nu = 12*gain;
ne = 6;
nl = 2;
iter = 50;
maxlag = max(ny, nu);

m1vib.EstimationConfigurations.MaxLength = 5000;
m1vib.Data.TransportDelay = [0 0];

pterms = 25;
eterms = 0;

[m1vib, results] = frols(m1vib, [ny nu ne nl], [pterms eterms], iter);

for i = 1:2
    plot_xcorrel(results.E, m1vib.Data.SystemInputs(:,i));
end

figure;
plot(results.E, 'k');

figure;
randregion = randi(30000, 1);
bvec = 1:10000 + randregion;
y0 = m1vib.Data.SystemOutput(1:maxlag);

generatesimfunc(m1vib, 'mancal1modelo', 1);
pause(0.1);
tic
Ys = mancal1modelo(m1vib.Data.SystemInputs, ones(30,1), 0);
toc
T = 1:length(Ys);
plot(T, m1vib.Data.SystemInputs, T, m1vib.Data.SystemOutput, T, Ys);
ylim([0 120]);

%figure;
%U = [40*ones(];
%Ys = mancal1modelo(



