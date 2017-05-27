function [ Xtrain, ytrain, Xtest, ytest ] = splitData( X, y, ratio )
% Splits data (X,y) into (Xtrain, ytrain, Xtest, ytest)
%  with a given ratio

nExamples = size(X,1);

perm = randperm(nExamples);
X = X(perm, :);
y = y(perm);

nTrain = round(ratio*nExamples);

Xtrain = X(1:nTrain, :);
ytrain = y(1:nTrain, :);

Xtest = X(nTrain+1:end, :);
ytest = y(nTrain+1:end, :);

end

