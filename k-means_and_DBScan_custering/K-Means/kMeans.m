function [centroids, idx] = kMeans(X, initial_centroids,max_iters, plot_progress)

if ~exist('plot_progress', 'var') || isempty(plot_progress)
    plot_progress = false;
end

if plot_progress
    figure;
    hold on;
end

% Initialize values
[m n] = size(X);
K = size(initial_centroids, 1);
centroids = initial_centroids;
previous_centroids = centroids;
idx = zeros(m, 1);

% Run K-Means
for i=1:max_iters
    
    fprintf('K-Means iteration %d/%d...\n', i, max_iters);
 
    % For each example in X, assign it to the closest centroid
    idx = findClosestCentroids(X, centroids);
    
    if plot_progress
        plotProgresskMeans(X, centroids, previous_centroids, idx, K, i);
        previous_centroids = centroids;
        fprintf('Press enter to continue.\n');
        pause;
    end
    
    %compute new centroids
    centroids = computeCentroids(X, idx, K);
end

% Hold off if we are plotting progress
if plot_progress
    hold off;
end

end

