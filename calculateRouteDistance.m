function distance = calculateRouteDistance(route, distMatrix)
distance = 0;
for i = 1:length(route) - 1
    distance = distance + distMatrix(route(i), route(i+1));
end
end
