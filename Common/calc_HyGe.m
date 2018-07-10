function HyGe = calc_HyGe (temp_complications, temp_clustering_result, cluster_no)

x = sum(temp_complications == 1 & temp_clustering_result == cluster_no);
M = length(temp_complications);
K = sum(temp_complications == 1);
n = sum(temp_clustering_result == cluster_no);

HyGe = hygecdf(x,M,K,n,'upper');
end