function idx = findClosestCentroids(X, centroids)

K = size(centroids, 1);

idx = zeros(size(X,1), 1);
data_len = size(X,1);

for i=1: data_len
    min_dist = 10000;
    
    for k=1:K
        dist = (X(i,1)-centroids(k,1)).^2 + (X(i,2)-centroids(k,2)).^2;
        if (dist<min_dist)
            min_dist = dist;
            idx(i,1) = k;   
        end
    end  
    
end

end

