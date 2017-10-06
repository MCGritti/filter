clear; clc;
close all;

load('dados/UpdatedDatasetWorkingData.mat');

E = dy;

T = dy(2:200);
X = dy(1:200-1);
theta = pinv(X) * T;
Yp = [0; dy(1:end-1)*theta];
E = dy - Yp;

f = y;
for i = 11:length(dy)
    P = dy(i-1) * theta;
    r = (dy(i) - P);
    if r^2 > 0.3
        f(i) = mean(f(i-10:i-1));
    end
end

figure;
plot([y, f]);

P = E;
figure;
plot([dy, Yp]);

figure;
plot(E.^2);

figure;
subplot(211);
autocorr(P);
subplot(212);
parcorr(P);