X=importdata('dataset.txt');

D=pdist2(X,X);
[M N]=size(D);
kDist=zeros(1,M);

MinPts=8;
for i=1:M;
    Z =sort(D(i,:));
    kDist(1,i) = Z(1,MinPts+1);
end
kDist1 = sort(kDist);

%plot k-dist vs datapoints
figure();
plot(kDist1);

%dbscan parameters
epsilon=.1;


figure();
scatter(X(:,1),X(:,2));
title('Original Datasets');

IDX=DBSCAN(D,epsilon,MinPts);
% K= max(IDX) for k mean clustering 

figure();
PlotClusterinResult(X, IDX);
title(['DBSCAN Clustering (\epsilon = ' num2str(epsilon) ', MinPts = ' num2str(MinPts) ')']);
