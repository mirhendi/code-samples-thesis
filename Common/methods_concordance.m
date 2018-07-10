%Salam
clc; clear all;
load clustering_results_all;
calc_NMI (HC_clusters, NC_clusters, 'NMI-HC-NC.txt');
calc_NMI (AP_clusters, NC_clusters, 'NMI-AP-NC.txt');
calc_NMI (AP_clusters, HC_clusters, 'NMI-AP-HC.txt');

function calc_NMI (clustering_1, clustering_2, file_name)
for i = 1:length(unique(clustering_1))
    for j = 1:length(unique(clustering_2))
        NMI_C1_C2 (i,j) = Cal_NMI(clustering_1 == i, clustering_2 == j)*100;
    end
end

fileID = fopen(['../Results/' file_name], 'w');
fprintf(fileID, ' & ');
for j = 1:length(unique(clustering_2))
    if j<length(unique(clustering_2))
        fprintf(fileID, '\\rot{Cluster \\#%d} & ', j);
    else
        fprintf(fileID, '\\rot{Cluster \\#%d} \\\\ \\hline\n', j);
    end
end

for i = 1:length(unique(clustering_1))
    fprintf(fileID, 'Cluster \\#%d & ', i);
    for j = 1:length(unique(clustering_2))
        if j < length(unique(clustering_2))
            fprintf(fileID, '%.1f & ', NMI_C1_C2(i,j));
        else
            fprintf(fileID, '%.1f \\\\\n', NMI_C1_C2(i,j));
        end
    end
end
fprintf(fileID, '\\hline');
end

