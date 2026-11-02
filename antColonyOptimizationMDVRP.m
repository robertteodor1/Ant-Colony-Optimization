
function [bestSolution, bestDistance, pheromones,solutions] = antColonyOptimizationMDVRP(numDepots, numCities, numVehicles, ...
    vehicleCapacities, cityDemands, distMatrix, params)


% Inițializare feromoni
numNodes = numDepots + numCities;
pheromones = ones(numNodes, numNodes);
bestSolution = [];
bestDistance = inf;

for iter = 1:params.maxIter
    solutions = cell(params.numAnts, 1);
    solutionDistances = zeros(params.numAnts, 1);

    for ant = 1:params.numAnts
        depotAssignments = randi(numDepots, 1, numVehicles);   % Asignarea depozitelor
        currentRoutes = cell(1, numVehicles);
        currentDistances = zeros(1, numVehicles);
        unvisitedCities = 1:numCities;                         % Toate orașele sunt inițial nevizitate

        for v = 1:numVehicles
            currentNode = depotAssignments(v);
            currentCapacity = vehicleCapacities(v);
            currentRoute = currentNode; 

            while ~isempty(unvisitedCities)
                probabilities = calculateProbabilities(currentNode, unvisitedCities, ...
                    distMatrix, pheromones, params.alpha, params.beta, currentCapacity, cityDemands);
                nextCityIdx = rouletteWheelSelection(probabilities);
                if isempty(nextCityIdx)
                    break; 
                end

                nextCity = unvisitedCities(nextCityIdx);
                currentCapacity = currentCapacity - cityDemands(nextCity);
                currentRoute = [currentRoute, numDepots + nextCity];
                currentNode = numDepots + nextCity;
                unvisitedCities(nextCityIdx) = []; % Marcăm orașele ca vizitate
            end

            currentRoute = [currentRoute, depotAssignments(v)];
            currentRoutes{v} = currentRoute;
            currentDistances(v) = calculateRouteDistance(currentRoute, distMatrix);
        end

        % Asignarea oricărui oraș rămas nevizitat
        if ~isempty(unvisitedCities)
            for city = unvisitedCities
               
                [minDist, nearestVehicle] = minRouteInsertion(city, currentRoutes, currentDistances, ...
                    distMatrix, vehicleCapacities, cityDemands, numDepots);
                if nearestVehicle > 0 
                    currentRoutes{nearestVehicle} = insertCityToRoute(city, currentRoutes{nearestVehicle}, distMatrix);
                    currentDistances(nearestVehicle) = minDist;
                else
                    
                    currentRoutes{end+1} = [city + numDepots, city + numDepots];
                    currentDistances(end+1) = 2 * distMatrix(city + numDepots, numDepots);
                end
            end
        end

        solutions{ant} = currentRoutes;
        solutionDistances(ant) = sum(currentDistances);
    end

 
    pheromones = (1 - params.evaporationRate) * pheromones;
    for ant = 1:params.numAnts
        routes = solutions{ant};
        distance = solutionDistances(ant);
        for v = 1:length(routes)
            route = routes{v};
            for i = 1:length(route) - 1
                pheromones(route(i), route(i+1)) = pheromones(route(i), route(i+1)) + params.Q / distance;
            end
        end
    end


    [minDistance, idx] = min(solutionDistances);
    if minDistance < bestDistance
        bestDistance = minDistance;
        bestSolution = solutions{idx};
    end

  
    fprintf('Iteration %d: Best Distance = %.2f\n', iter, bestDistance);
end
end
