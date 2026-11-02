function [minDist, nearestVehicle] = minRouteInsertion(city, routes, distances, distMatrix, capacities, demands, numDepots)
minDist = inf;
nearestVehicle = -1;
cityIndex = city + numDepots;

for v = 1:length(routes)
    route = routes{v};
    if sum(demands(route(route > numDepots) - numDepots)) + demands(city) > capacities(v)
        continue; 
    end
    for i = 1:length(route) - 1
        newDist = distances(v) + distMatrix(route(i), cityIndex) + distMatrix(cityIndex, route(i+1)) - distMatrix(route(i), route(i+1));
        if newDist < minDist
            minDist = newDist;
            nearestVehicle = v;
        end
    end
end
end


