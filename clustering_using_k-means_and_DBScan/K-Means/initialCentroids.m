function centroids = initialCentroids(X, K)
%set centroids to randomly chosen examples from  the dataset X

[m,n] = size(X);
index=randperm(m,K);
centroids = X(index,:);

end

