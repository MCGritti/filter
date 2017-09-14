clear; clc;
close all;

load('dados/FirstDatasetWorkingData.mat');
u1 = data(:,1);
u2 = data(:,2);
y  = data(:,3);
taxa_corr = zeros(size(y));
offset = 40;
taxa_corr(525:809+offset) = -0.279648606;
taxa_corr(981:1248+offset) = -0.171166593;

c1 = 1.50e-2;
c2 = 0.45 * c1;
c3 = 6.800584169e-4;
c4 = 2.52 * 0.45;
c5 = 24 * 365;

k1 = c2;
k2 = c1 - c3 * c4;
k3 = c4;

% (0,45*0,0001*150)/(0,0001*150-(L2+0,0006800584169)*2,52*0,45)
ref_corr = 0.45 + cumsum(taxa_corr) / c5;
% int_corr_ohm = 0.0150 / (2.52 * 0.45) - const - 0.0150./(2.52 * int_corr);
trans = @(x) k1 ./ (k2 - k3*x);
yt = trans(y);
ref_ohm = k2/k3 - k1 ./ (ref_corr * k3);
plot([y,ref_ohm]);

M = length(y);
cm = 200;

% Filtros
fir = fir_filter(y, ones(48,1));
iir = iir_filter(y, [0.1 0.1 0.1 0.1 0.1 0.1]);
mmqb = els_filter(y, 50, 1);
mmqd = els_filter(y, 200, 0.95);
mmqd = iir_filter(mmqd, [0.45 0.45]);
cels = cels_filter(y, 190, 0.99);

for i = cm:M-cm
    if cels(i) > cels(i-1)
        cels(i) = cels(i-1);
    end
end

t = (0:M-1)' * 3600;
cut = cm:M;
plot(t(cut), y(cut), 'k.'); hold on;
plot(t(cut), fir(cut), 'ro', 'markersize', 3, 'markerfacecolor', 'r');
plot(t(cut), iir(cut), 'bo', 'markersize', 3, 'markerfacecolor', 'b');
plot(t(cut), mmqb(cut), 'go', 'markersize', 3, 'markerfacecolor', 'g');
plot(t(cut), mmqd(cut), 'co', 'markersize', 3, 'markerfacecolor', 'c');
h = legend('Original', 'FIR', 'IIR', 'MMQb', 'MMQd');
set(h, 'interpreter', 'latex');

figure;
cut = cm:M-cm;
plot(t(cut), y(cut), 'k.'); hold on;
plot(t(cut), cels(cut), 'ro', 'markersize', 3, 'markerfacecolor', 'r');
legend('Noisy', 'CMMQ');

figure;
const = 24 * 365;
dc = [0; diff(trans(cels)) * const];
dfir = [0; diff(trans(fir)) * const];
dmmq = [0; diff(trans(mmqd)) * const];
t = t / 3600;
plot(t(cut), dc(cut), 'r', 'linewidth', 2); hold on;
plot(t(cut), dfir(cut), 'k:', 'linewidth', 2);
plot(t(cut), dmmq(cut), 'b:', 'linewidth', 2);
plot(t(cut), taxa_corr(cut), 's');
ylabel('$dy / dt$', 'interpreter', 'latex');
xlabel('Tempo', 'interpreter', 'latex');
h = legend('CMMQ', 'Resultado M\`{e}dia M\`{o}vel (48)', 'Location', 'best');
set(h, 'interpreter', 'latex');