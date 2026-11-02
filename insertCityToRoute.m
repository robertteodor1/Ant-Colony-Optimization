function route = insertCityToRoute(city, route, distMatrix)
cityIndex = city + size(distMatrix, 1) - length(route);
bestInsertion = inf;
bestPos = -1;

for i = 1:length(route) - 1
    insertionCost = distMatrix(route(i), cityIndex) + distMatrix(cityIndex, route(i+1)) - distMatrix(route(i), route(i+1));
    if insertionCost < bestInsertion
        bestInsertion = insertionCost;
        bestPos = i;
    end
end
route = [route(1:bestPos), cityIndex, route(bestPos+1:end)];


 if bestPos == -1
        route = [route, cityIndex];
    else
        % Inserăm orașul la poziția optimă găsită
        route = [route(1:bestPos), cityIndex, route(bestPos+1:end)];
    end
end