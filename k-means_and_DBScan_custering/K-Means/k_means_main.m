clear ; close all; clc

fprintf('\nRunning K-Means clustering.\n\n');
X = importdata('dataset.txt');

K = 7;
max_iters = 1;

initial_centroids = initialCentroids(X,K);

[centroids, idx] = kMeans(X, initial_centroids, max_iters, true);

fprintf('\nK-Means Done.\n\n');
