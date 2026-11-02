function idx = rouletteWheelSelection(probabilities)
cumulativeProb = cumsum(probabilities);
r = rand;
idx = find(r <= cumulativeProb, 1);
end
