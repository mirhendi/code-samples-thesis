function latex_clusters_stats_table (clusters_stats_table, file_name)
fileID = fopen(['../Results/' file_name], 'w');

fprintf(fileID, [' & Cluster Size & Male(\\%%) & Female(\\%%) & ' ...
    'Weight (kg) & Age \\\\ \\hline \n']);

for i = 1:size(clusters_stats_table,2)
    fprintf(fileID, ['Cluster \\#' num2str(i) ' & ']);
    fprintf(fileID, '%d & ', clusters_stats_table{1,i});
    fprintf(fileID, '%.1f & ', clusters_stats_table{2,i});
    fprintf(fileID, '%.1f & ', clusters_stats_table{3,i});
    fprintf(fileID, '%.1f $\\pm$ %.1f & ', clusters_stats_table{4,i}, clusters_stats_table{5,i});
    fprintf(fileID, '%.1f $\\pm$ %.1f \\\\', clusters_stats_table{6,i}, clusters_stats_table{7,i});
    if i ~= size(clusters_stats_table,2)
        fprintf(fileID,  '\n');
    else
        fprintf(fileID,  '\\hline');
    end
end

end
