function latex_networks_concordance (networks_concordance)
fileID = fopen(['../Results/' 'SNF-networks-concordance.txt'], 'w');
fprintf(fileID, ' & ');

fprintf(fileID, '\\rot{Fused Network} & ');
for i = 2:size(networks_concordance, 2)
    if i < size(networks_concordance, 2)
        fprintf(fileID, '\\rot{Network \\#%d} & ', i-1);
    else
        fprintf(fileID, '\\rot{Network \\#%d} \\\\ \\hline\n', i-1);
    end
end

fprintf(fileID, 'Fused Network & ');
for i = 1:size(networks_concordance, 1)
    if i~=1 
        fprintf(fileID, 'Network \\#%d & ', i-1);
    end
    for j = 1:size(networks_concordance, 2)
        if i>=j
            fprintf(fileID, ' %.1f', networks_concordance(i,j)*100);
        else
            fprintf(fileID, '-');
        end
        if j < size(networks_concordance, 2)
            fprintf(fileID, ' &');
        else
            fprintf(fileID, ' \\\\\n');
        end
    end
end
fprintf(fileID, '\\hline');
end