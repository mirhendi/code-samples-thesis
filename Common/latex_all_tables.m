function latex_all_tables (result_table, fileID, complication_name, clustering_method)
result_table = table2array(result_table);
fprintf(fileID, ['\\begin{muntab}{ccccccc}{}{' clustering_method ' clustering results for ' complication_name '}{} \n']);
%fprintf(fileID, '\\hline \\hline \n');
%fprintf(fileID, ['\\multicolumn{7}{c}{' complication_name '} \\\\ \\hline \\hline \n']);
fprintf(fileID, ['P$_{HG}$ & '...
    'RR & '...
    'OR & '...
    'Cluster \\# & '...
    '\\#PCC & '...
    '\\#CLS & '...
    '\\#CMP \\\\ \\hline \n']);
for i = 1:size(result_table,1)
    for j = 1:7
        if j==1
            fprintf(fileID, '%.2E ', result_table(i,j));
        elseif 2<=j && j<=3
            fprintf(fileID, '%.2f ', result_table(i,j));
        elseif 4<=j && j<=7
            fprintf(fileID, '%d ', result_table(i,j));
        end
        if j~=7
            fprintf(fileID, '& ');
        end
    end
    fprintf(fileID, '\\\\ ');
    if i ~= size(result_table,1)
        fprintf(fileID, '\n');
    end
end
fprintf(fileID, '\\hline \n');
fprintf(fileID, ['\\end{muntab}\n'])

