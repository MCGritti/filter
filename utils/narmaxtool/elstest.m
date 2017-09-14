clear all;
clc; close all;

%% Test els.m file

U = [zeros(10,1); 2*ones(100,1); 5*ones(50,1); 5*exp(-(0:200)'/50); 10-10*exp(-(0:200)'/50); zeros(50,1)];
U = [U;U];
Y = zeros(size(U));

N = length(U);
% Model equation 
% y[k] = 0.8y[k-1]-0.4y[k-5]+0.2u[k-2]+0.3u[k-5]+0.2e[k-2]+0.3e[k-5]+e[k]
% e[k] = gauss(0, 0.1);
E = 1*randn(N, 1);
%Yr = Y;
%E = zeros(N,1);
for k = 2:N
    if k < 3
        Y(k) = 0.8*Y(k-1) + E(k);
    elseif k >= 3 && k < 6
        Y(k) = 0.8*Y(k-1) + 0.2*U(k-2) + E(k);
    elseif k >= 6
        Y(k) = 0.8*Y(k-1) - 0.4*Y(k-5) + 0.2*U(k-2) + 0.6*U(k-5) + E(k);
    end
end

[theta, Yp, R, equation] = els(Y, U, [1 5], [2 5], [], [0.1 0.1]);

t = (0:N-1)';
figure('position', [0 0 600 400]);
plot(t, U, t, Y, t, Yp);
figure('position', [600 0 600 400]); plot(t, E, t, R);
legend('Original', 'Predicted');

std(E)
disp([theta(1:4)'; 0.8 -0.4 0.2 0.6]);

disp(theta');

Z = zeros(N, 1);
for k = 2:N
    if k < 3
        Z(k) = theta(1)*Z(k-1);
    elseif k >= 3 && k < 6
        Z(k) = theta(1)*Z(k-1) + theta(3)*U(k-2);
    elseif k >= 6
        Z(k) = theta(1)*Z(k-1) + theta(2)*Z(k-5) + theta(3)*U(k-2) + theta(4)*U(k-5);
    end
end

figure('position', [1200 0 600 400]);
plot(t, Y, t, Z);

figure('position', [0 400 600 400]);
plotcorr(E);
