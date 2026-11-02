% Scriptul Main al algoritmul ACO pentru MDVRP-HV
clc;
clear;
close all;
% loadedData=load('date_neextins.mat')
% table_data=loadedData.p03;
% data = table2array(table_data);



% load('date_neextins.mat')
load('data01.mat')
% load('data02.mat')
% load('data03.mat')


numDepots = data(1,3);
numCities = data(1,2);
numVehicles = data(1,1);
vehicleCapacities = data(2:numVehicles+1,2)';


cityDemands = data(numVehicles+2:numCities+numVehicles+1, 5)';
depotPositions = data(numVehicles+numCities+2:numVehicles+numCities+numDepots+1, 2:3);
cityPositions=data(numVehicles+2:numVehicles+numCities+1, 2:3);
sum=0;

for i=1:numCities
    sum=cityDemands(i)+sum;
end
% Distance matrix
positions = [depotPositions; cityPositions];
numNodes = numDepots + numCities;
distMatrix = squareform(pdist(positions));


% Parametrii ACO (Ant Colony Optimization)
params.numAnts = 30;               % Numărul de furnici utilizate în fiecare iterație
params.maxIter = 100;              % Numărul maxim de iterații ale algoritmului
params.alpha = 1;                  % Influenta feromonilor în decizia de alegere
params.beta = 2;                   % Influenta distanței (euristicii) în decizia de alegere
params.evaporationRate = 0.3;     % Rata de evaporare a feromonilor
params.Q = 100;                   % Constanta de depunere a feromonului (cantitatea de feromon depusă)



[bestSolution, bestDistance, pheromones,solutions] = antColonyOptimizationMDVRP(numDepots, numCities, numVehicles, ...
    vehicleCapacities, cityDemands, distMatrix, params);

disp('Best Solution:');
disp(bestSolution);
fprintf('Best Total Distance: %.2f\n', bestDistance);


figure;
hold on;
scatter(depotPositions(:, 1), depotPositions(:, 2), 100, 'r', 'filled', 'DisplayName', 'Depots');
scatter(cityPositions(:, 1), cityPositions(:, 2), 50, 'b', 'filled', 'DisplayName', 'Cities');
for v = 1:numVehicles
    route = bestSolution{v};
    routePositions = positions(route, :);
    plot(routePositions(:, 1), routePositions(:, 2), '-o', 'DisplayName', sprintf('Route %d', v));
end
legend;
hold off;

% Creare simulare live ACO

figure;
hold on;
title('Simulare Live - Mișcarea Furnicilor și Feromonii', 'FontSize', 14);

% Inițializare trasee cu feromoni
cmapFeromoni = repmat([0.85, 0.85, 1], 256, 1);
lineHandles = gobjects(numNodes, numNodes);
for i = 1:numNodes
    for j = i+1:numNodes
        if pheromones(i, j) > 0
            lineHandles(i, j) = plot([positions(i, 1), positions(j, 1)], [positions(i, 2), positions(j, 2)], ...
                'Color', cmapFeromoni(1, :), 'LineWidth', 0.5, 'HandleVisibility', 'off');
        end
    end
end

% Culori unice pentru fiecare vehicul
colors = lines(numVehicles);

% Inițializare marker pentru fiecare furnică
antMarkers = gobjects(numVehicles, 1);
for v = 1:numVehicles
    if ~isempty(bestSolution{v})
        antMarkers(v) = plot(positions(bestSolution{v}(1), 1), positions(bestSolution{v}(1), 2), ...
            'ko', 'MarkerSize', 10, 'MarkerFaceColor', 'k', 'DisplayName', sprintf('Furnică %d', v));

    end
end

% Inițializare marker pentru orașe (invizibile la început)
cityMarkers = gobjects(numCities, 1);
for c = 1:numCities
    cityMarkers(c) = scatter(NaN, NaN, 80, 'k', 'filled', 'Visible', 'off'); % Inițializare invizibilă
end

% Legendă pentru rutele optime
routeHandles = gobjects(numVehicles, 1);

% Iterare pentru animație
for iter = 1:params.maxIter
    scatter(depotPositions(:, 1), depotPositions(:, 2), 150, 'ro', 'filled', 'LineWidth', 2, 'DisplayName', 'Depouri');
    % Actualizare trasee cu feromoni
    for i = 1:numNodes
        for j = i+1:numNodes
            if pheromones(i, j) > 0
                set(lineHandles(i, j), 'Color', cmapFeromoni(1, :), 'LineWidth', 0.5);
            end
        end
    end

    % Simulare mișcare furnici (cu interpolare lină și viteză mai mare)
    for v = 1:numVehicles
        route = bestSolution{v};
        if isempty(route), continue; end

        for step = 2:length(route)
            startPos = positions(route(step-1), :);
            endPos = positions(route(step), :);
            currentNode = route(step);




            numSteps = 10;
            for t = linspace(0, 1, numSteps)
                interpPos = (1 - t) * startPos + t * endPos;



                pause(0.005); % Pauză mai scurtă pentru o viteză mai mare
            end


            if currentNode > numDepots
                cityIndex = currentNode - numDepots;
                set(cityMarkers(cityIndex), 'XData', positions(currentNode, 1), ...
                    'YData', positions(currentNode, 2), ...
                    'Visible', 'on');
            end

            % Adăugare traseu vizibil parcurs
            if iter == 1 && step == 2
                routeHandles(v) = plot([startPos(1), endPos(1)], [startPos(2), endPos(2)], ...
                    '-', 'Color', colors(v, :), 'LineWidth', 3, 'DisplayName', sprintf('Rută %d', v));
            else
                plot([startPos(1), endPos(1)], [startPos(2), endPos(2)], ...
                    '-', 'Color', colors(v, :), 'LineWidth', 3);
            end
        end

    end

    % Evaporare feromoni
    pheromones = (1 - params.evaporationRate) * pheromones;

    drawnow;
    % Oprire simulare daca ajunge in orasul 1
    if currentNode == route(1)
        disp(['Furnica ', num2str(v), ' s-a întors la orașul de start. Simularea s-a oprit.']);
        break;
    end
end


hold off;

