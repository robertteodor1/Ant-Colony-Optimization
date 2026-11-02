function cost = calculateRouteCost(route, costMatrix)
    cost = 0;
    for i = 1:(length(route) - 1)
        cost = cost + costMatrix(route(i), route(i + 1));
    end
end