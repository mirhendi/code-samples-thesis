%Salam
clc; clear;
%%
load clustering_results_all;
load clusters_bootstrap_all;
load complications_dataset;
%%
or_table_KM = or_table(KM_clusters, complications_data);
or_table_HC = or_table(HC_clusters, complications_data);
or_table_AP = or_table(AP_clusters, complications_data);
or_table_NC = or_table(NC_clusters, complications_data);

p_value_KM = p_value_calc(or_table_KM, bootstrap_or_table_KM);
p_value_HC = p_value_calc(or_table_HC, bootstrap_or_table_HC);
p_value_AP = p_value_calc(or_table_AP, bootstrap_or_table_AP);
p_value_NC = p_value_calc(or_table_NC, bootstrap_or_table_NC);
save('p_value_all_clustering.mat', 'p_value_KM', 'p_value_HC', 'p_value_AP', 'p_value_NC');

latex_p_value_table (p_value_KM, 'p-value-table-KM.txt', complications_name);
latex_p_value_table (p_value_HC, 'p-value-table-HC.txt', complications_name)
latex_p_value_table (p_value_AP, 'p-value-table-AP.txt', complications_name)
latex_p_value_table (p_value_NC, 'p-value-table-NC.txt', complications_name)

%%
function p_value_table = p_value_calc(or_table, bootstrap_or_table)
for i = 1:size(or_table,1)
    for j = 1:size(or_table,2)
        p_value = sum(squeeze(bootstrap_or_table(i,j,:)) >= or_table(i,j)) / size (bootstrap_or_table,3);
        p_value_table (i,j) = p_value;
    end
end
end

function complication_cluster_or = or_table(clustering_result, complications_data)
cluster_eval_result = cluster_eval_calc (clustering_result, complications_data);
for i = 1:size(cluster_eval_result, 1) % no of clusters
    for j = 1:size(cluster_eval_result, 3) % no of complications
        cluster_index = find(cluster_eval_result(:,4,j) == i);
        complication_cluster_or (j,i) = cluster_eval_result(cluster_index,3,j);
    end
end
complication_cluster_or(complication_cluster_or == inf) = 10;
end

function latex_p_value_table (p_value_table, file_name, complications_name)
fileID = fopen(['../Results/' file_name], 'w');
fprintf(fileID, ' & ');
for i = 1:size(p_value_table, 2)
    if i < size(p_value_table, 2)
        fprintf(fileID, '\\rot{Cluster \\#%d} & ', i);
    else
        fprintf(fileID, '\\rot{Cluster \\#%d} \\\\ \\hline\n', i);
    end
end

for i = 1:size(p_value_table, 1)
    fprintf(fileID, ' %s & ', complications_name{i});
    for j = 1:size(p_value_table, 2)
        if p_value_table(i,j) <0.1
            fprintf(fileID, ' \\hl{%.3f}', p_value_table(i,j));
        else
            fprintf(fileID, ' %.3f', p_value_table(i,j));
        end

        if j < size(p_value_table, 2)
            fprintf(fileID, ' &');
        else
            fprintf(fileID, ' \\\\\n');
        end
    end
end
fprintf(fileID, '\\hline');
end