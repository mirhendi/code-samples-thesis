
% https://en.wikipedia.org/wiki/Diagnostic_odds_ratio

function OR = calc_OR (temp_complications, temp_clustering_result, cluster_no)
DE = sum(temp_complications == 1 & temp_clustering_result == cluster_no);
HE = sum(temp_complications == 0 & temp_clustering_result == cluster_no);
DN = sum(temp_complications == 1 & temp_clustering_result ~= cluster_no);
HN = sum(temp_complications == 0 & temp_clustering_result ~= cluster_no);

OR = (DE/HE)/(DN/HN);
end

