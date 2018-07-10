%Salam
clc; clear;
load complications_dataset
load top_result_tables
load p_value_all_clustering

global complications_name_table;
complications_name_table = cell2table(complications_name', 'VariableNames', {'Complication_name'});

top_result_table_prepare(top_result_table_KM, p_value_KM, 'selected-results-KM.txt');
top_result_table_prepare(top_result_table_HC, p_value_HC, 'selected-results-HC.txt');
top_result_table_prepare(top_result_table_AP, p_value_AP, 'selected-results-AP.txt');
top_result_table_prepare(top_result_table_NC, p_value_NC, 'selected-results-NC.txt');

function top_result_table_prepare(top_result_table, p_value_array, file_name)
global complications_name_table;
p_values = zeros(size(p_value_array,1),1);
for i = 1:size(p_value_array,1)
    p_values(i) = p_value_array(i, top_result_table{i,4});
end
top_result_table.p_Val = p_values;
top_result_table = [top_result_table(:, 1:3) top_result_table(:,8) top_result_table(:,4:7)];
top_result_table = horzcat(complications_name_table, top_result_table);
top_result_table = sortrows(top_result_table, 4, 'descend');
latex_selected_result_table (top_result_table, file_name);
end



