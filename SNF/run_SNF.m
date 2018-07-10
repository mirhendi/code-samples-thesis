% Salam
clc; clear; close all;
warning off;
addpath(genpath('../../MATLAB'));
addpath(genpath('../Common'));

%% Data initialization
% Read data
data_table = readtable('clean_data.csv');
features_name = data_table.Properties.VariableNames;
data = zeros(size(data_table));
for i = 1: size(data_table,2)
    if iscell(data_table{1,i})
        data(:, i) = cellfun(@str2double, data_table{:, i});
    else
        data(:, i) = data_table {:, i};
    end
end
raw_data = data;
load complications_dataset

%% Categorize Data
for i = 1: size(data,2)
    table(length(unique(data(:, i))), 'VariableNames', features_name(i));
end
network_col = [];
network_col{1} = [1 11 18 20 21]; % Ordinal
network_col{2} = [5:10 26]; % Numeric
network_col{3} = [2:4 12 15:17 19 22 25 27 147]; % Binary
network_col{4} = [13:14 23:24]; % Numeric
network_col{5} = 28:51; % Binary
network_col{6} = [52:146 148:436]; % Categorical
distane_type = {'squaredeuclidean' 'squaredeuclidean' 'hamming' 'squaredeuclidean' 'hamming' 'hamming'};

%% Data Imputation
for i = cat(2, network_col{1}, network_col{3}, network_col{5}, network_col{6})
    data(isnan(data(:,i)),i) = mode(data(:,i));
end

for i = cat(2, network_col{2}, network_col{4})
    data(isnan(data(:,i)),i) = mean(data(:,i), 'omitnan');
end

%% Data Normalization
for i = cat(2, network_col{1}, network_col{2}, network_col{4})
    data(:,i) = Standard_Normalization(data(:,i));
end

%% Data Distance Calc
for i = 1: length(network_col)
    network_dist{i} = squareform(pdist(data(:,network_col{i}) ,distane_type{i}));
end

%% Loop over parameters
% K number of neighbors, usually (10~30)
% alpha hyperparameter, usually (0.3~0.8)
% T Number of Iterations, usually (10~20)
for T = 25
    for alpha = 0.8
        for K = 15
            %% SNF
            for i = 1: length(network_col)
                W{i} = affinityMatrix(network_dist{i}, K, alpha);
            end
            W_all = SNF(W(1:length(network_col)), K, T);
            OCN = zeros(2,2); % Optimal Cluster Numbers
            [OCN(1,1), OCN(2,1), OCN(1,2), OCN(2,2)] = Estimate_Number_of_Clusters_given_graph(W_all, 2:20);
            fprintf('The best number of clusters according to eigengap is %d\n', OCN(1,1));
            fprintf('The second best number of clusters according to eigengap is %d\n', OCN(1,2));
            fprintf('The best number of clusters according to rotation cost is %d\n', OCN(2,1));
            fprintf('The second best number of clusters according to rotation cost is %d\n', OCN(2,2));
            
            no_clusters = OCN(2,1);
            clustering_result = SpectralClustering(W_all, no_clusters);
            displayClusters(W_all, clustering_result);
            color_map_clusters = jet(length(unique(clustering_result)));
            
            networks_concordance = Concordance_Network_NMI([W_all,W], no_clusters);
            latex_networks_concordance(networks_concordance);
            
            cluster_eval_result = cluster_eval_calc (clustering_result, complications_data);
            clusters_stats (clustering_result, raw_data, 'cluster-stats-NC.txt');
            
            my_heatmap (cluster_eval_result, complications_name);
            title('SNF Network Clustring');

            table_var_names = [{'Hy_Ge'} {'Risk_Ratio'} {'Ods_Ratio'} ...
                {'Cluster_label'} ...
                {'Patients_with_this_complication_in_cluster'} ...
                {'Total_patients_in_cluster'} ...
                {'Total_patients_with_this_complication'} ];
            
            fileID = fopen(['../Results/' 'all-clustering-results-SNF.txt'], 'w');
            fprintf(fileID, '\\clearpage \n\\subsection{Network Clustering} \n');

            top_result_table = [];
            figure('Position', [100 100 1000 625]);
            for i = 1: length(complications_name)
                result_table = array2table(cluster_eval_result(:, :, i), 'VariableNames', table_var_names);
                latex_all_tables (result_table, fileID, complications_name{i}, 'Network')

                result_table = result_table(result_table{:,5}>3, :);
                if ~isempty(result_table)
                    display(['Complication: ' complications_name{i}])
                    result_table
                    top_result_table = vertcat(top_result_table, result_table(1, :));
                    my_scatter (result_table, i, complications_name, color_map_clusters)
                end
            end
            my_scatter_legend(clustering_result);
            title('SNF Network Clustering');
            
            top_result_table_NC = top_result_table;
            save('../Common/top_result_tables', 'top_result_table_NC','-append');            
        end
    end
end

