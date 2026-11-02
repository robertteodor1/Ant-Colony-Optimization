
function pheromone = updatePheromones(pheromone, routes, routeCosts, rho)
    numNodes = size(pheromone, 1);

    % Evaporare feromoni
    pheromone = (1 - rho) * pheromone;

    % Depozitul feromonilor
    for k = 1:length(routes)
        route = routes{k};
        cost = routeCosts(k);

        for i = 1:(length(route) - 1)
            pheromone(route(i), route(i + 1)) = pheromone(route(i), route(i + 1)) + 1 / cost;
            pheromone(route(i + 1), route(i)) = pheromone(route(i + 1), route(i)) + 1 / cost;
        end
    end
end