clear all;
clc;
close all;

N = 1000;
mu = [2 2; 0 0; -3 3];
K = 3;
X = [0.5*randn(N, 2)+repmat(mu(1,:), N, 1); ...
     0.5*randn(N, 2)+repmat(mu(2,:), N, 1); ...
     0.5*randn(N, 2)+repmat(mu(3,:), N, 1)];
     
[means, cov, rot, sigma, groups, meanspath] = kmeans(X, K, 20, 0.9);

plot(X(:,1), X(:,2), 'k.'); hold on;

theta = linspace(0, 2*pi+0.1, 100)';
for k = 1:K
  plot(means{k}(1), means{k}(2), 'x', 'markersize', 25, 'linewidth', 5);
  plot(means{k}(1), means{k}(2), 'x', 'markersize', 20, 'linewidth', 3, 'color', [1 0 0], 'markerfacecolor', [1 0 0]);
  plot(meanspath{k}(:,1), meanspath{k}(:,2), 'linewidth', 2);
  x = 1.96*sqrt(sigma{k}(1,1))*cos(theta);
  y = 1.96*sqrt(sigma{k}(2,2))*sin(theta);
  vec = [x y]*inv(rot{k}) + means{k};
  plot(vec(:,1), vec(:,2), 'color', [1 0 0], 'linewidth', 2);
  inverse{k} = inv(sigma{k});
end

axis('equal')

xmin = -6;
xmax = 6;
ymin = -6;
ymax = 6;
xp   = 120;
yp   = 120;

points = [];
x = linspace(xmin, xmax, xp);
y = linspace(ymin, ymax, yp);

for k = 1:xp
   points = [points; repmat(x(k), yp, 1), y'];
end

%figure;
colors = [eye(3); rand(10, 3)];

for k = 1:K
  proj = (points - repmat(means{k}, xp*yp, 1))*rot{k};
  prob = exp( -diag(proj * inverse{k} * proj')/2 );% / sqrt( (2*pi)^2 * det( sigma{k} ) );
  subidxs = prob > 0.1;
  plot3(points(subidxs,1), points(subidxs,2), prob(subidxs), '.', 'color', colors(k,:));
  hold on;
end



