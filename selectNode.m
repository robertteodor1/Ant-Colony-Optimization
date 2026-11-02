function nextNode = selectNode(probabilities, visited)

    % Selectează aleatoriu un nod pe baza probabilităților

    cumulativeSum = cumsum(probabilities);      % Calculează suma cumulativă a probabilităților
    r = rand();                                
    nextNode = find(cumulativeSum >= r, 1);     % Găsește primul nod pentru care suma cumulativă depășește r

    % Soluție de rezervă dacă nextNode este gol (din cauza unor erori numerice sau logice)
    if isempty(nextNode)
        unvisited = find(~visited);                      % Găsește nodurile nevizitate
        nextNode = unvisited(randi(length(unvisited)));  % Selectează aleatoriu unul dintre nodurile nevizitate
    end
end
