function centroids = computeCentroids(X, idx, K)

[m n] = size(X);
centroids = zeros(K, n);

for k=1:K
    
    sum =zeros(1,n);
    count=0;
    
    for i=1:m
        
        if idx(i)== k
            sum = sum + X(i,:);
            count = count +1;
        end
        
    end
    
    centroids(k,:) = sum/count;
    
end

end

