function clusters_stats (clustering_result, raw_data, file_name)
var_names = cell(1, length(unique(clustering_result)));
for i = 1:length(unique(clustering_result))
    gender_percentage (1,i) = 100*sum(raw_data(clustering_result == i, 12) == 1)/length(raw_data(clustering_result == i, 12));
    gender_percentage (2,i) = 100*sum(raw_data(clustering_result == i, 12) == 0)/length(raw_data(clustering_result == i, 12));
    average_weight (1, i) = mean (raw_data(clustering_result == i, 13))/2.2;
    std_weight (1, i) = std (raw_data(clustering_result == i, 13)./2.2);
    average_age (1, i) = mean (raw_data(clustering_result == i, 23), 'omitnan');
    std_age (1, i) = std (raw_data(clustering_result == i, 23), 'omitnan');
    cluster_population (1, i) = sum(clustering_result == i);
    var_names{i} = ['Cluster_' num2str(i)];
end
display(['No of Clusters: ' num2str(length(cluster_population))]);
display(['Clusters Population Avg: ' num2str(mean(cluster_population))]);
display(['Clusters Population SD: ' num2str(std(cluster_population))]);
display(['Clusters Population Median: ' num2str(median(cluster_population))]);
display(['Clusters Population Max: ' num2str(max(cluster_population))]);
display(['Clusters Population Min: ' num2str(min(cluster_population))]);

cluster_population = array2table(cluster_population, 'VariableNames', var_names, 'RowNames', {'Cluster Population'});
gender_percentage = array2table(gender_percentage, 'VariableNames', var_names, 'RowNames', {'Male (%)' 'Female (%)'});

average_weight = array2table(average_weight, 'VariableNames', var_names, 'RowNames', {'Weight Average(kg)'});
std_weight = array2table(std_weight, 'VariableNames', var_names, 'RowNames', {'Weight SD(kg)'});

average_age = array2table(average_age, 'VariableNames', var_names, 'RowNames', {'Age'});
std_age = array2table(std_age, 'VariableNames', var_names, 'RowNames', {'Age SD'});

clusters_stats_table = vertcat(cluster_population, gender_percentage, average_weight, std_weight, average_age, std_age);
latex_clusters_stats_table (clusters_stats_table, file_name)
display(clusters_stats_table)
end