function my_scatter_legend(clusters)
set(gcf,'renderer','painters');
cluster_population(length(unique(clusters))) = 0;
for i = 1:length(unique(clusters))
    cluster_population(i) = sum(clusters == i);
end
cluster_population = cluster_population';
color_map_clusters = jet(length(unique(clusters)));
legend_plot_handle = zeros(length(unique(clusters)),1);
for i = 1:length(unique(clusters))
    legend_plot_handle(i) = scatter(NaN, NaN, 1, color_map_clusters(i,:), ...
        'filled', 'MarkerFaceAlpha',.5 , 'MarkerEdgeColor', 'k', 'MarkerEdgeAlpha', 0.5);
end
legend_text = arrayfun(@(x,y){sprintf('Cluster %d (Size = %d)',x, y)}, sort(unique(clusters)), cluster_population);
legend(legend_plot_handle, legend_text, 'FontSize', 12);

% auto_xlim = xlim;
xlim([2.5 12.5])
ylim([0 6.3])

yt = yticklabels;
yt{end} = '>=6';
yticklabels(yt);

xt = xticklabels;
xt{end} = '>=12';
xticklabels(xt);

end