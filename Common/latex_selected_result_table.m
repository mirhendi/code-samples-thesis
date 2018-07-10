
function latex_selected_result_table (top_result_table, file_name)
fileID = fopen(['../Results/' file_name], 'w');
fprintf(fileID, [' & ' ...
    'OR & '...
    '$p$-value & '...
    'Cluster \\# & '...
    '\\#PCC & '...
    '\\#CLS & '...
    '\\#CMP \\\\ \\hline \n']);

for i = 1:size(top_result_table, 1)
    fprintf(fileID, '%s', [top_result_table{i ,1}{1} ' & ']);
    for j = 4:size(top_result_table, 2)
        if j==4 
            fprintf(fileID, '%.2f ', top_result_table{i,j});
        elseif j==5 
            fprintf(fileID, '%.3f ', top_result_table{i,j});
        elseif 6<=j && j<=9
            fprintf(fileID, '%d ', top_result_table{i,j});
        end
        if j~=9
            fprintf(fileID, '& ');
        end
    end
    fprintf(fileID, '\\\\ \n');
end
fclose(fileID);
end
