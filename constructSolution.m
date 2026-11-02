
function route = constructSolution(costMatrix, pheromone, alpha, beta)
    numNodes = size(costMatrix, 1);
    visited = false(1, numNodes);
    route = zeros(1, numNodes + 1);

    % Start de la un nod oarecare
    currentNode = randi(numNodes);
    route(1) = currentNode;
    visited(currentNode) = true;

   
    for step = 2:numNodes
        probabilities = calculateProbabilities(currentNode, visited, costMatrix, pheromone, alpha, beta);
        nextNode = selectNode(probabilities, visited);
        route(step) = nextNode;
        visited(nextNode) = true;
        currentNode = nextNode;
    end

    % Întoarcerea la punctul de plecare inițial
    route(end) = route(1);
end