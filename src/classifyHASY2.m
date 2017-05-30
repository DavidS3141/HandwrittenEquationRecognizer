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

%% %% %% %% Loop on number of classes
nClassesList = [12:2:28];

mse = zeros(size(nClassesList,2), 5);
timeTrain = mse;
timePredict = timeTrain;
oldclock = clock;

nDim = 64;

for i = 1:length(nClassesList)
    
nClasses = nClassesList(i);
disp(['Number of classes is ', num2str(nClasses)]);

Xcut = X(y<nClasses+1,:);
ycut = y(y<nClasses+1);

%% Dimensionality reduction
if(size(Xcut,1) < size(Xcut,2))
    warning(['PCA might lead to an unexpected result -',...
        '- X has not got enough examples... S1=',...
        num2str(size(Xcut,1)),...
        ' has to be highet than S2=',...
        num2str(size(Xcut,2))]);
else
    [coeffs, Xpca, ~, ~, ~] = pca(Xcut);
end

%% Split train-test!
trainRatio = 0.6;
[XtrainFull, ytrain, XtestFull, ytest] = splitData(Xpca, ycut, trainRatio);

%% nDim
Xtrain = XtrainFull(:, 1:nDim);
Xtest = XtestFull(:, 1:nDim);

% KNN
[mse(i,1), ~, ~, timeTrain(i,1), timePredict(i,1)] = modelError('knn', Xtrain, ytrain, Xtest, ytest);

% Bayes
[mse(i,2), ~, ~, timeTrain(i,2), timePredict(i,2)] = modelError('bayes', Xtrain, ytrain, Xtest, ytest);

% Tree
[mse(i,3), ~, ~, timeTrain(i,3), timePredict(i,3)] = modelError('tree', Xtrain, ytrain, Xtest, ytest);

% Linear discriminant
[mse(i,4), ~, ~, timeTrain(i,4), timePredict(i,4)] = modelError('lda', Xtrain, ytrain, Xtest, ytest);

% Binary SVMs
[mse(i,5), ~, ~, timeTrain(i,5), timePredict(i,5)] = modelError('svm', Xtrain, ytrain, Xtest, ytest);
end
disp(' End prediction');

mdlLabels = {'knn','bayes', 'tree', 'lda', 'svm'};

plotModelsData(nClassesList, mse, mdlLabels, 'Comparison of misclassification rate between models', 'Misclassification rate');
plotModelsData(nClassesList, timeTrain, mdlLabels, 'Comparison of training time', 'Training time');
plotModelsData(nClassesList, timePredict, mdlLabels, 'Comparison of predict time', 'Predict time');
plotModelsData(nClassesList, timeTrain+timePredict, mdlLabels, 'Comparison of total time', 'Total time');

disp(['Total runtime is ', num2str(clock - oldclock)]);