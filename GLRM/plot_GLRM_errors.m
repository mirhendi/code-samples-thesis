%Salam
clc; clear; close all;

error_table = readtable('all_error_table.csv');
error_table (:,1) = [];
header_names = error_table.Properties.VariableNames;
P_Rank_K = 1;
P_Gamma_X = 2;
P_Omega = 3;
P_Fold_No = 4;
P_TrainMSE = 5;
P_TrainMCR = 6;
P_TestMSE = 7;
P_TestMCR = 8;

error_array = (table2array (error_table));
error_array = sortrows(error_array,[P_Gamma_X P_Omega P_Rank_K P_Fold_No]);


fold_no = 0;
error_array_3d = NaN(sum(error_array(:, P_Fold_No) == 1), 8, 5);
for row_number = 1 : size(error_array, 1)
    if error_array(row_number, 4) == 1
        fold_no = fold_no +1;
    end
    error_array_3d(fold_no, :, error_array(row_number, P_Fold_No)) = error_array (row_number, :);
end


omegas = sort(unique(error_array(:, P_Omega, 1)));
gammas = sort(unique(error_array(:, P_Gamma_X, 1)));
ranks = sort(unique(error_array(:, P_Rank_K, 1)));

%% Error as a fucntion of k for constant gamma
for j = 1: numel(gammas)
    array_gamma_const = error_array_3d((error_array_3d(:, P_Gamma_X, 1) == gammas(j)),:,:);
%     for i = 5:8
%         array_gamma_const(:, i, :) = array_gamma_const(:, i, :)/max(max(array_gamma_const(:, i, :)));
%         array_gamma_const(:, i, :) = array_gamma_const(:, i, :)/max(max(array_gamma_const(:, i, :)));
%         array_gamma_const(:, i, :) = array_gamma_const(:, i, :)/max(max(array_gamma_const(:, i, :)));
%         array_gamma_const(:, i, :) = array_gamma_const(:, i, :)/max(max(array_gamma_const(:, i, :)));
%     end
    %% MCR
    legend_marks = {};
    figure; hold on;
    title(['MCR Error as a fucntion of k, for Gamma = ' num2str(gammas(j))])
    xlabel('K')
    ylabel('MCR Error')
    for i = 1:numel(omegas)
        array_omega_gamma_const = array_gamma_const((array_gamma_const(:, P_Omega, 1) == omegas(i)), :, :);
        array_mean = mean(array_omega_gamma_const, 3);
        array_std = std(array_omega_gamma_const, 0, 3);
        
        errorbar(array_mean(:, P_Rank_K), array_mean(:, P_TrainMCR), array_std(:, P_TrainMCR))
        errorbar(array_mean(:, P_Rank_K), array_mean(:, P_TestMCR), array_std(:, P_TestMCR))
        legend_marks = [legend_marks, {['Train MCR, \omega = ' num2str(omegas(i))], ...
            ['Test MCR, \omega = ' num2str(omegas(i))]}];
    end
    legend (legend_marks); hold off;
    
    %% MSE
    legend_marks = {};
    figure; hold on;
    title(['MSE Error as a fucntion of k, for Gamma = ' num2str(gammas(j))])
    xlabel('K')
    ylabel('MSE Error')
    for i = 1:numel(omegas)
        array_omega_gamma_const = array_gamma_const((array_gamma_const(:, P_Omega, 1) == omegas(i)), :, :);
        array_mean = mean(array_omega_gamma_const, 3);
        array_std = std(array_omega_gamma_const, 0, 3);
    
        errorbar(array_mean(:, P_Rank_K), array_mean(:, P_TrainMSE), array_std(:, P_TrainMSE))
        errorbar(array_mean(:, P_Rank_K), array_mean(:, P_TestMSE), array_std(:, P_TestMSE))
        legend_marks = [legend_marks, {['Train MSE, \omega = ' num2str(omegas(i))], ...
            ['Test MSE, \omega = ' num2str(omegas(i))]}];
    end
    legend (legend_marks); hold off;
end
% 
% %% Error as a fucntion of gamma for constant omega
% for j = 1:numel(omegas)
%     
%     array_omega_const = error_array_3d((error_array_3d(:, P_Omega, 1) == omegas(j)),:,:);
% %     for i = 5:8
% %         array_omega_const(:, i, :) = array_omega_const(:, i, :)/max(max(array_omega_const(:, i, :)));
% %         array_omega_const(:, i, :) = array_omega_const(:, i, :)/max(max(array_omega_const(:, i, :)));
% %         array_omega_const(:, i, :) = array_omega_const(:, i, :)/max(max(array_omega_const(:, i, :)));
% %         array_omega_const(:, i, :) = array_omega_const(:, i, :)/max(max(array_omega_const(:, i, :)));
% %     end
%     
%     %% MCR
%     legend_marks = {};
%     figure; hold on;
%     title(['MCR Error as a fucntion of gamma , for Omega = ' num2str(omegas(j))])
%     xlabel('Gamma')
%     ylabel('MCR Error')
%     for i = 1:numel(ranks)
%         array_rank_omega_const = array_omega_const((array_omega_const(:, P_Rank_K, 1) == ranks(i)), :, :);
%         array_mean = mean(array_rank_omega_const, 3);
%         array_std = std(array_rank_omega_const, 0, 3);
%         
%         errorbar(array_mean(:, P_Gamma_X), array_mean(:, P_TrainMCR), array_std(:, P_TrainMCR))
%         errorbar(array_mean(:, P_Gamma_X), array_mean(:, P_TestMCR), array_std(:, P_TestMCR))
%         legend_marks = [legend_marks, {['Train MCR K = ' num2str(ranks(i))], ...
%             ['Test MCR K = ' num2str(ranks(i))]}]; 
%     end
%     legend (legend_marks); hold off;
% 
%     %% MSE
%     legend_marks = {};
%     figure; hold on;
%     title(['MSE Error as a fucntion of gamma , for Omega = ' num2str(omegas(j))])
%     xlabel('Gamma')
%     ylabel('MSE Error')
%     for i = 1:numel(ranks)
%         array_rank_omega_const = array_omega_const((array_omega_const(:, P_Rank_K, 1) == ranks(i)), :, :);
%         array_mean = mean(array_rank_omega_const, 3);
%         array_std = std(array_rank_omega_const, 0, 3);
% 
%         errorbar(array_mean(:, P_Gamma_X), array_mean(:, P_TrainMSE), array_std(:, P_TrainMSE))
%         errorbar(array_mean(:, P_Gamma_X), array_mean(:, P_TestMSE), array_std(:, P_TestMSE))
%         legend_marks = [legend_marks, {['Train MSE K = ' num2str(ranks(i))], ...
%             ['Test MSE K = ' num2str(ranks(i))]}];
%         ylabel('MSE Error')
%     end
%     legend (legend_marks); hold off;
% end
% 
% %% Error as a fucntion of omega for constant gamma
% for j = 1:numel(gammas)
%     array_gamma_const = error_array_3d((error_array_3d(:, P_Gamma_X, 1) == gammas(j)),:,:);
% %     for i = 5:8
% %         array_gamma_const(:, i, :) = array_gamma_const(:, i, :)/max(max(array_gamma_const(:, i, :)));
% %         array_gamma_const(:, i, :) = array_gamma_const(:, i, :)/max(max(array_gamma_const(:, i, :)));
% %         array_gamma_const(:, i, :) = array_gamma_const(:, i, :)/max(max(array_gamma_const(:, i, :)));
% %         array_gamma_const(:, i, :) = array_gamma_const(:, i, :)/max(max(array_gamma_const(:, i, :)));
% %     end
%     
%     %% MCR
%     legend_marks = {};
%     figure; hold on;
%     title(['MCR Error as a fucntion of Omega , for Gamma = ' num2str(gammas(j))])
%     xlabel('Omega')
%     ylabel('MCR Error')
%     for i = 1:numel(ranks)
%         array_rank_gamma_const = array_gamma_const((array_gamma_const(:, P_Rank_K, 1) == ranks(i)), :, :);
%         array_mean = mean(array_rank_gamma_const, 3);
%         array_std = std(array_rank_gamma_const, 0, 3);
%         
%         errorbar(array_mean(:, P_Omega), array_mean(:, P_TrainMCR), array_std(:, P_TrainMCR))
%         errorbar(array_mean(:, P_Omega), array_mean(:, P_TestMCR), array_std(:, P_TestMCR))
%         legend_marks = [legend_marks, {['Train MCR K = ' num2str(ranks(i))], ...
%             ['Test MCR K = ' num2str(ranks(i))]}];
%     end
%     legend (legend_marks); hold off;
% 
%     legend_marks = {};
%     figure; hold on;
%     title(['MSE Error as a fucntion of Omega , for Gamma = ' num2str(gammas(j))])
%     xlabel('Omega')
%     ylabel('MSE Error')
%     
%     for i = 1:numel(ranks)
%         array_rank_gamma_const = array_gamma_const((array_gamma_const(:, P_Rank_K, 1) == ranks(i)), :, :);
%         array_mean = mean(array_rank_gamma_const, 3);
%         array_std = std(array_rank_gamma_const, 0, 3);
% 
%         errorbar(array_mean(:, P_Omega), array_mean(:, P_TrainMSE), array_std(:, P_TrainMSE))
%         errorbar(array_mean(:, P_Omega), array_mean(:, P_TestMSE), array_std(:, P_TestMSE))
%         legend_marks = [legend_marks, {['Train MSE K = ' num2str(ranks(i))], ...
%             ['Test MSE K = ' num2str(ranks(i))]}];
%     end
%     legend (legend_marks); hold off;
% end
