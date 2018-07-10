function cluster_eval_result = cluster_eval_calc (clustering_result, complications_data)

% x - number of patients with complication in the cluster
% M = total number of patients
% K = total number of patients with that complication
% n = number of patients in the cluster

for complication_no = 1: size(complications_data, 2)
    non_missing_rows = find(~isnan(complications_data(:, complication_no)));
    temp_complications = complications_data (non_missing_rows, complication_no);
    temp_clustering_result = clustering_result (non_missing_rows, :);
    
    for cluster_no = 1: max(clustering_result)
        
        x = sum(temp_complications == 1 & temp_clustering_result == cluster_no);
        M = length(temp_complications);
        K = sum(temp_complications == 1);
        n = sum(clustering_result == cluster_no);


        RR = calc_RR (temp_complications, temp_clustering_result, cluster_no);
        HyGe = calc_HyGe (temp_complications, temp_clustering_result, cluster_no);
        OR = calc_OR (temp_complications, temp_clustering_result, cluster_no);
        
        cluster_eval_result (cluster_no, 1, complication_no) = HyGe;
        cluster_eval_result (cluster_no, 2, complication_no) = RR;
        cluster_eval_result (cluster_no, 3, complication_no) = OR;
        cluster_eval_result (cluster_no, 4, complication_no) = cluster_no; % Cluster Label
        cluster_eval_result (cluster_no, 5, complication_no) =  x; % Number of patients with complication in the cluster
        cluster_eval_result (cluster_no, 6, complication_no) =  n; % Number of patients in the cluster
        cluster_eval_result (cluster_no, 7, complication_no) =  K; % Total number of patients with that complication
    end
end

for i = 1: 1: size(complications_data, 2)
    cluster_eval_result(:, :, i) = sortrows (cluster_eval_result(:, :, i), -3);
end

end