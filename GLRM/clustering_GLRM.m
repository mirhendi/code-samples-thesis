% Salam
clc; clear; close all;
warning off
addpath(genpath('../../MATLAB'));
addpath(genpath('../Common'));
complete_run = false;

% Read data
data_table = readtable('clean_data.csv');
raw_data = zeros(size(data_table));
for i = 1: size(data_table,2)
    if iscell(data_table{1,i})
        raw_data(:, i) = cellfun(@str2double, data_table{:, i});
    else
        raw_data(:, i) = data_table {:, i};
    end
end

load complications_dataset
color_map_patients = hsv(length(complications_name));

model = readtable('glrm_model_x.csv');
model = table2array (model);
if complete_run
    [KM_clusters, HC_clusters, AP_clusters] = clustering (model);
    save('clustering_results.mat', 'KM_clusters', 'HC_clusters', 'AP_clusters');
else
    load clustering_results_GLRM;
end

%% Bootstrap 
% No_bootstaps = 2;
% bootsrtp_data = zeros(size(model));
% for i = 1: No_bootstaps
%     for j= 1: size(model, 1)
%         bootsrtp_data(j,:) = datasample(model(j, :), size(model, 2));
%     end
%     [bstrp_KM_clusters, bstrp_HC_clusters, bstrp_AP_clusters] = clustering (bootsrtp_data);
%     KM_jcrd_coeff(i, :) = calc_jcrd (KM_clusters, bstrp_KM_clusters);
%     HC_jcrd_coeff(i, :) = calc_jcrd (HC_clusters, bstrp_HC_clusters);
%     AP_jcrd_coeff(i, :) = calc_jcrd (AP_clusters, bstrp_AP_clusters);
% end
% 
% figure; hold on; title('KM Jcrd Hist');
% bar(1:size(KM_jcrd_coeff,2), mean (KM_jcrd_coeff));
% errorbar(1:size(KM_jcrd_coeff,2), mean(KM_jcrd_coeff), std(KM_jcrd_coeff)/2, '.');
% 
% figure; hold on; title('HC Jcrd Hist');
% bar(1:size(HC_jcrd_coeff,2), mean (HC_jcrd_coeff));
% errorbar(1:size(HC_jcrd_coeff,2), mean(HC_jcrd_coeff), std(HC_jcrd_coeff)/2, '.');
% 
% figure; hold on; title('AP Jcrd Hist');
% bar(1:size(AP_jcrd_coeff,2), mean (AP_jcrd_coeff));
% errorbar(1:size(AP_jcrd_coeff,2), mean(AP_jcrd_coeff), std(AP_jcrd_coeff)/2, '.');
% 
% KM_significant_cluster = find(mean(KM_jcrd_coeff) > 0.5);
% HC_significant_cluster = find(mean(HC_jcrd_coeff) > 0.5);
% AP_significant_cluster = find(mean(AP_jcrd_coeff) > 0.5);

%% Table initialization
table_var_names = [{'Hy_Ge'} {'Risk_Ratio'} {'Ods_Ratio'} ...
    {'Cluster_label'} ...
    {'Patients_with_this_complication_in_cluster'} ...
    {'Total_patients_in_cluster'} ...
    {'Total_patients_with_this_complication'} ];

fileID = fopen(['../Results/' 'all-clustering-results-GLRM.txt'], 'w');

%% K-means Clustering
clusters_stats (KM_clusters, raw_data, 'cluster-stats-KM.txt');
KM_cluster_eval_result = cluster_eval_calc (KM_clusters, complications_data);
color_map_clusters = jet(length(unique(KM_clusters)));
my_heatmap (KM_cluster_eval_result, complications_name)
title('K-means Clustering');

fprintf(fileID, '\\clearpage \n\\subsection{$K$-means Clustering} \n');
top_result_table = [];

figure;
for i = 1: length(complications_name)
    result_table = array2table(KM_cluster_eval_result(:, :, i), 'VariableNames', table_var_names);
    latex_all_tables (result_table, fileID, complications_name{i}, '$k$-means') 

    %     [~,Locb] = ismember(KM_significant_cluster, result_table{:,4});
    %     result_table = result_table(Locb, :);
    result_table = result_table(result_table{:,5}>3, :);
    if ~isempty(result_table)
        display('K-means Clustering')
        display(['Complication: ' complications_name{i}])
        result_table
        top_result_table = vertcat(top_result_table, result_table(1, :));
        my_scatter (result_table, i, complications_name, color_map_clusters)
    end
end
my_scatter_legend(KM_clusters)
title('K-means Clustering');
top_result_table_KM = top_result_table;
save('../Common/top_result_tables', 'top_result_table_KM');
%% Hierarchical Clustering
clusters_stats (HC_clusters, raw_data, 'cluster-stats-HC.txt');
HC_cluster_eval_result = cluster_eval_calc (HC_clusters, complications_data);
color_map_clusters = jet(length(unique(HC_clusters)));

my_heatmap (HC_cluster_eval_result, complications_name)
title('Hierarchical Clustering');

fprintf(fileID, '\\clearpage \n\\subsection{Hierarchical Clustering} \n');
top_result_table = [];

figure;
for i = 1: length(complications_name)
    result_table = array2table(HC_cluster_eval_result(:, :, i), 'VariableNames', table_var_names);
    latex_all_tables (result_table, fileID, complications_name{i}, 'Hierarchical') 

    %     [~,Locb] = ismember(HC_significant_cluster, result_table{:,4});
    %     result_table = result_table(Locb, :);
    result_table = result_table(result_table{:,5}>3, :);
    if ~isempty(result_table)
        display('Hierarchical Clustering')
        display(['Complication: ' complications_name{i}])
        result_table
        top_result_table = vertcat(top_result_table, result_table(1, :));
        my_scatter (result_table, i, complications_name, color_map_clusters)
    end
end
my_scatter_legend(HC_clusters)
title('Hierarchical Clustering');
top_result_table_HC = top_result_table;
save('../Common/top_result_tables', 'top_result_table_HC','-append');
%% Affinity Propagation Clustering
clusters_stats (AP_clusters, raw_data, 'cluster-stats-AP.txt');
AP_cluster_eval_result = cluster_eval_calc (AP_clusters, complications_data);
color_map_clusters = jet(length(unique(AP_clusters)));

my_heatmap (AP_cluster_eval_result, complications_name)
title('Affinity Propagation Clustering');

fprintf(fileID, '\\clearpage \n\\subsection{Affinity Propagation Clustering} \n');
top_result_table = [];

figure;
for i = 1: length(complications_name)
    result_table = array2table(AP_cluster_eval_result(:, :, i), 'VariableNames', table_var_names);
    latex_all_tables (result_table, fileID, complications_name{i}, 'Affinity Propagation') 
    %     [~,Locb] = ismember(AP_significant_cluster, result_table{:,4});
    %     result_table = result_table(Locb, :);
    result_table = result_table(result_table{:,5}>3, :);
    if ~isempty(result_table)
        display('Affinity Propagation')
        display(['Complication: ' complications_name{i}])
        result_table
        top_result_table = vertcat(top_result_table, result_table(1, :));
        my_scatter (result_table, i, complications_name, color_map_clusters)
    end
end
my_scatter_legend(AP_clusters)
title('Affinity Propagation Clustering');
top_result_table_AP = top_result_table;
save('../Common/top_result_tables', 'top_result_table_AP','-append');
%% All clustering results
all_clusters_lables = array2table([[1:size(model, 1)]', AP_clusters, KM_clusters, HC_clusters], ...
    'VariableNames', {'Patient_ID'  'AP_clusters' 'KM_clusters' 'HC_clusters'});
%save('all_clusters_lables.mat', 'all_clusters_lables');