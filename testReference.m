clear; clc;
close all;

load dados/FirstDatasetWorkingData.mat;

DZ = makeReference(DZ, 1, 60);
Z = cumsum(DZ) / dt + e0;
z = corr2ohm(Z, k1, k2, k3);
dz = [0; diff(z)] * dt;


plot([y, z]);