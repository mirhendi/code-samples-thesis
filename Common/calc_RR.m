
% https://en.wikipedia.org/wiki/Relative_risk

function RR = calc_RR (temp_complications, temp_clustering_result, cluster_no)
de = sum(temp_complications == 1 & temp_clustering_result == cluster_no);
he = sum(temp_complications == 0 & temp_clustering_result == cluster_no);
dn = sum(temp_complications == 1 & temp_clustering_result ~= cluster_no);
hn = sum(temp_complications == 0 & temp_clustering_result ~= cluster_no);

RR = (de/(de+he))/(dn/(dn+hn));
end

