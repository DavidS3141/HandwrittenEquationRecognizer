%% Clear
clear;
clc;
close all;

%% Read data
symbolFilePath = '../data/extract/symbols.csv';
symbolFile = fopen(symbolFilePath);
symbolMap = textscan(symbolFile, '%s %s %s %s', 'Delimiter', ',');

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
y = y(1:n);

for ii=1:n
    img = a(:,:,ii);
    X(ii, :) = img(:)'; % X(ii, :) is an image as a row
end

% The image can be retrieved by reshaping to [sizeImg, sizeImg]

%% Shuffle
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
trainProp = 0.8;
testProp = 1 - trainProp;

nTrain = round(trainProp*n);

Xtrain = X(1:nTrain, :);
ytrain = y(1:nTrain, :);

Xtest = X(nTrain+1:end, :);
ytest = y(nTrain+1:end, :);


%% Classify
nExamples = 10000;
% nExamples = size(a,3);
perm2 = randperm(nExamples);

mdl = fitcknn(Xtrain(perm2, :), ytrain(perm2), 'NumNeighbors', 5);

ypred = mdl.predict(Xtest);
mr = mean(ypred ~= ytest)
%L = mdl.loss(Xtest, ytest);
