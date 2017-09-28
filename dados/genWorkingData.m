clear; clc;
close all;

load LastDataset;

l = 150.37;
d = 2.25;
e0 = 0.3;
res = 1e-4;
dr = 5.158645695e-5;

% ( e0 * res * l ) ./ ( res * l + d * e0 * v5 - d * e0 * x )
k1 = e0 * res * l;
k2 = res * l + d * e0 * dr;
k3 = d * e0;
dt = 8760;

u1 = RcorrAbsOhm;
u2 = RreffAbsOhm;
y = DeltaRAbsOhm;
dy = [0; diff(y)] * dt;
Y = ohm2corr(y, k1, k2, k3);
DY = [0; diff(Y)] * dt;
plot([ef, Y]);

r1 = 1:91;
r2 = 92:207;
r3 = 208:332;
r4 = 333:374;

DZ  = zeros(size(DY));
DZ(r1) = -0.0037;
DZ(r2) = -0.4904;
DZ(r3) = -0.1594;
DZ(r4) = -0.4139;
Z = e0 + cumsum(DZ) / dt;
z = corr2ohm(Z, k1, k2, k3);
dz = [0; diff(z)] * dt;

clear r1 r2 r3 r4;

clear l d res dr RcorrAbsOhm RcorrAbs Data DataTime
clear RreffAbs RreffAbsOhm DeltaRAbsOhm TimeStamp ef

save('LastDatasetWorkingData.mat');

% LastDataset
% r1 = 1:91;
% r2 = 92:207;
% r3 = 208:332;
% r4 = 333:374;
% 
% DZ  = zeros(size(DY));
% DZ(r1) = -0.0037;
% DZ(r2) = -0.4904;
% DZ(r3) = -0.1594;
% DZ(r4) = -0.4139;
% Z = e0 + cumsum(DZ) / dt;
% z = corr2ohm(Z, k1, k2, k3);
% dz = [0; diff(z)] * dt;


