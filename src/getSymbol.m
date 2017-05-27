function [ symbol, nTrain, nTest ] = getSymbol( symbolMap, nr )
% getSymbol: returns the symbol associated to the identifier n
%  in the symbolMap
% nTrain: number of training examples
% nTest: number of test examples

symbol = 0;
nTrain = 0;
nTest = 0;
for i=1:length(symbolMap{1})
    if(strcmp(symbolMap{1}(i, :), num2str(nr)))
        symbol = symbolMap{2}(i, :);
        symbol = symbol{1};
        nTrain = symbolMap{3}(i, :);
        nTest = symbolMap{4}(i, :);
    end
end

end

