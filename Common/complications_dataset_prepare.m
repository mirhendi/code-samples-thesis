complications_table = readtable('complications_data.csv');
complications_name = complications_table.Properties.VariableNames;
for i = 1: length(complications_name)
    complications_name{i} = strrep(complications_name{i},'_',' ');
    complications_name{i} = strrep(complications_name{i},' new','');
    complications_name{i} = strrep(complications_name{i},'DKA','Diabetic ketoacidosis');
    complications_name{i} = strrep(complications_name{i},'dyslipidemia high cholesterol','Dyslipidemia');
    idx = regexp([' ' complications_name{i}],'(?<=\s+)\S','start')-1;
    complications_name{i}(idx) = upper(complications_name{i}(idx));
end

complications_data = zeros(size(complications_table));
for i = 1: size(complications_table,2)
    if iscell(complications_table{1,i})
        complications_data(:, i) = cellfun(@str2double, complications_table{:, i});
    else
        complications_data(:, i) = complications_table {:, i};
    end
end
complications_data(isnan(complications_data)) = 0;
save('complications_dataset.mat', 'complications_name', 'complications_data');