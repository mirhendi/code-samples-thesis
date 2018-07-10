% Salam
% Cluster the input model using three clustering methods (KM, HC, AP)

function [KM_clusters, HC_clusters, AP_clusters] = clustering (model)
KM_clusters = kmeans(model, 10);
% evalclusters(model,'kmeans','CalinskiHarabasz','KList',[3:20])
% evalclusters(model,'kmeans','DaviesBouldin','KList',[3:20])
% evalclusters(model,'kmeans','gap','KList',[3:20])
% evalclusters(model,'kmeans','silhouette','KList',[3:20])

% disp ('hc');

HC_model_distances = pdist(model);
HC_model_linkage = linkage(HC_model_distances, 'ward');
figure; dendrogram(HC_model_linkage, 0); title('Hierarchical Clustering Dendrogram')
hline = refline([0 12]);
hline.Color = 'r';
hline.LineStyle = '--';
hline.LineWidth = 1;

HC_clusters = cluster(HC_model_linkage, 'maxclust', 9);
% evalclusters(model,'linkage','CalinskiHarabasz','KList',[3:20])
% evalclusters(model,'linkage','DaviesBouldin','KList',[3:20])
% evalclusters(model,'linkage','gap','KList',[3:20])
% evalclusters(model,'linkage','silhouette','KList',[3:20])


AP_model_distances = -pdist(model);
Ap_preference = prctile(AP_model_distances,25);
AP_similarity = squareform(AP_model_distances);
[AP_idx, ~, ~, ~] = apcluster(AP_similarity, median(AP_model_distances), 'nonoise');
AP_clusters = AP_idx (:, end);
AP_cluster_labels = sort(unique(AP_clusters));
AP_clusters = changem(AP_clusters, 1:length(AP_cluster_labels), AP_cluster_labels);
end
