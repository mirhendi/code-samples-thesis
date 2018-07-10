% Salam
% Calculate Jaccard similarity coefficient
function all_jcrd_coeff = calc_jcrd (original_clusters, bootstrap_clusters)
original_labels = sort(unique(original_clusters))';
bootstrap_labels = sort(unique(bootstrap_clusters))';
jcrd_matrix(length(bootstrap_labels), length(original_labels)) = 0;
for original_label = original_labels
    for bootstrap_label = bootstrap_labels
       jcrd_coeff = sum(original_clusters == original_label & bootstrap_clusters == bootstrap_label) ...
           /sum(original_clusters == original_label | bootstrap_clusters == bootstrap_label);
       jcrd_matrix(bootstrap_label, original_label) = jcrd_coeff;
    end
end

%% Jcrd Table:
% Original Label
% Bootstrap Label
% Jcrd Coeff
jcrd_table (1, :) = 1:length(original_labels);
[jcrd_table(3, :), jcrd_table(2, :)] = max(jcrd_matrix);
all_jcrd_coeff = jcrd_table(3, :);
end

