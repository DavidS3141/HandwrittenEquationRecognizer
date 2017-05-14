%% Clear
clear;
clc;
close all;

%% Read data
symbolFilePath = '../data/extract/symbols.csv';
symbolFile = fopen(symbolFilePath);
symbolMap = textscan(symbolFile, '%s %s %s %s', 'Delimiter', ',');
sym = getSymbol(symbolMap, 323);


labelFilePath = '../data/extract/hasy-data-labels.csv';
labelFile = fopen(labelFilePath);
labelStruct = textscan(labelFile, '%s %s %s %s', 'Delimiter', ',');
y = cellfun(@str2double, labelStruct{2}(2:end));

fclose('all');

%% Load images
imgPath = '../data/extract/HASYv2_logical.mat';
load(imgPath);

n = size(a,3);

%% Reshape features vector
sizeImg = 32;
X = zeros(n, sizeImg^2);

for ii=1:n
    img = a(:,:,ii);
    X(ii, :) = img(:)'; % X(ii, :) is an image as a row
end

% The image can be retrieved by reshaping to [sizeImg, sizeImg]

%% Shuffle
% xverif = X(1231, :);
% yverif = y(1231);
% 
% xverif2 = X(perm(1231), :);
% yverif2 = y(perm(1231));

perm = randperm(n);
X = X(perm, :);
y = y(perm);


%% Display several images
nImg = 3;
idx = randsample(1:n, nImg);

for i=idx
   figure;
   imshow(reshape(X(i, :), [sizeImg, sizeImg]));
end

%% Split train-test
trainProp = 0.7;
testProp = 1 - trainProp;

nTrain = round(trainProp*n);

Xtrain = X(1:nTrain, :);
ytrain = y(1:nTrain, :);

Xtest = X(nTrain+1:end, :);
ytest = y(nTrain+1:end, :);


%% Classify
nExamples = nTrain;
% nExamples = size(a,3);
perm2 = randperm(nExamples);

% KNN
numNeighbors = 7;
knn = fitcknn(Xtrain(perm2, :), ytrain(perm2), 'NumNeighbors', numNeighbors);

ypredNN = knn.predict(Xtest);
mrNN = mean(ypredNN ~= ytest)
% 
% % Bayes
% bay = fitNaiveBayes(Xtrain, ytrain);
% ypredBay = bay.predict(Xtest);
% mrBay = mean(ypredBay ~= ytest)
% %cMat1 = confusionmat(species,C1) 

% Tree
tree = fitctree(Xtrain(perm2, :), ytrain(perm2));

ypredTree = tree.predict(Xtest);
mrTree = mean(ypredTree ~= ytest)


% Linear discriminant
lin = fitcdiscr(Xtrain(perm2, :), ytrain(perm2));
ypredLin = predict(lin, Xtest);
mrLin = mean(ypredLin ~= ytest)

% quadclass = fitcdiscr(meas,species,...
%     'discrimType','quadratic');
% meanclass2 = predict(quadclass,meanmeas)


