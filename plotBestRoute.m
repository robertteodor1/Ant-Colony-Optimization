function plotBestRoute(route, costMatrix,coord)
numNodes = size(costMatrix, 1);
coords = coord;
figure;
hold on;


plot(coords(:, 1), coords(:, 2), 'ro', 'MarkerSize', 10, 'LineWidth', 1.5);
for i = 1:numNodes
    text(coords(i,1) + 1, coords(i,2) + 1, sprintf('City %d', i), 'FontSize', 8, 'Color', 'blue');
end

for i = 1:(length(route) - 1)
    plot(coords(route(i:i+1), 1), coords(route(i:i+1), 2), 'b-', 'LineWidth', 1.5);
end

title('Best Route');
grid on;
end
