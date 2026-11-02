function probabilities = calculateProbabilities(currentNode, remainingCities, distMatrix, pheromones, alpha, beta, capacity, demands)
numDepots = size(pheromones, 1) - length(demands);
probabilities = zeros(1, length(remainingCities));
for i = 1:length(remainingCities)
    city = remainingCities(i);
    if demands(city) > capacity
        continue;   % trecem peste soluțiile nefezabile
    end
    cityIndex = numDepots + city;
    tau = pheromones(currentNode, cityIndex);
    eta = 1 / distMatrix(currentNode, cityIndex);
    probabilities(i) = tau^alpha * eta^beta;
end
probabilities = probabilities / sum(probabilities);
end
