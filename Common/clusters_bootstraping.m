%Salam
clc; clear all;
%%
load clustering_results_all;
load complications_dataset;
bootstrap_or_table_KM = calc_bootstrap(KM_clusters, complications_data);
bootstrap_or_table_HC = calc_bootstrap(HC_clusters, complications_data);
bootstrap_or_table_AP = calc_bootstrap(AP_clusters, complications_data);
bootstrap_or_table_NC = calc_bootstrap(NC_clusters, complications_data);
save('clusters_bootstrap_all.mat', 'bootstrap_or_table_KM', 'bootstrap_or_table_HC', 'bootstrap_or_table_AP', 'bootstrap_or_table_NC')
%%
function all_complication_cluster_or = calc_bootstrap(clustering_result, complications_data)
for no_bootstrap = 1:10000
    random_clustering = datasample(clustering_result,length(clustering_result),'Replace',false);
    cluster_eval_result = cluster_eval_calc (random_clustering, complications_data);
    for i = 1:size(cluster_eval_result, 1) % no of clusters
        for j = 1:size(cluster_eval_result, 3) % no of complications
            cluster_index = find(cluster_eval_result(:,4,j) == i);
            complication_cluster_or (j,i) = cluster_eval_result(cluster_index,3,j);
        end
    end
    complication_cluster_or(complication_cluster_or == inf) = 10;
    all_complication_cluster_or(:,:,no_bootstrap) = complication_cluster_or;
end
end
    
    