%% Clear
clear;
clc;
close all;

%% Read data
[a, y, symbolMap] = loadHASY;

n = size(a,3);
assert(n == length(y));

% Reshape features vector
sizeImg = 32;
X = zeros(n, sizeImg^2);

for ii=1:n
    img = a(:,:,ii);
    X(ii, :) = img(:)'; % X(ii, :) is an image as a row
end

clear a;
% The image can be retrieved by reshaping to [sizeImg, sizeImg]

%% Transform labels from 31:xx:1400 to 1:369
y = transformLabels(y, symbolMap{1});


%% %% %% %% 
nTrainClasses = 369;

Xcut = X(y<nTrainClasses+1,:);
ycut = y(y<nTrainClasses+1);

%% Dimensionality reduction
if(size(Xcut,1) < size(Xcut,2))
    warning('PCA might lead to an unexpected result -- X has not got enough examples');
else
    [coeffs, Xpca, ~, ~, explained] = pca(Xcut);
end

%% Split train-test!
trainRatio = 0.6;
[XtrainFull, ytrain, XtestFull, ytest] = splitData(Xpca, ycut, trainRatio);

%% Train models
nDim =64;

Xtrain = XtrainFull(:, 1:nDim);
Xtest = XtestFull(:, 1:nDim);


%% Save models
load('~/Desktop/MatlabMDL/mdlKnn.mat');
load('~/Desktop/MatlabMDL/mdlBayes.mat');
load('~/Desktop/MatlabMDL/mdlTree.mat');
load('~/Desktop/MatlabMDL/mdlLda.mat');

%% Find misclassified examples

ypred = mdlLda.predict(Xtest);

XtestReconstruct = XtestFull * coeffs';
misIdx = find(ypred ~= ytest);

%% Output misclassified examples
nOutput = 10;
idx = randsample(misIdx, nOutput);

for i=idx'
    img = reshape(XtestReconstruct(i, :), [32 32]);
    figure;
    predLabel = cell2mat(symbolMap{2}(ypred(i)+1,:));
    trueLabel = cell2mat(symbolMap{2}(ytest(i)+1,:));
    imagesc(img); colormap(gray);
    titleStr = ['Predicted: ', num2str(predLabel),...
        '; True: ', num2str(trueLabel)];
    title(titleStr);
    set(gca,'fontsize',18);
end


