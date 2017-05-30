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

%% Display several images
nImg = 0;
idx = randsample(1:n, nImg);

if(nImg==0)
    disp('No image to display - Skipping this section');
else
% print images
for i=idx
   figure;
   imshow(reshape(X(i, :), [sizeImg, sizeImg]));
   label = y(i);
   symbol = getSymbol(symbolMap,label);
   title(sprintf('%i',i));
   set(gca,'fontsize',18);
end

pause;
close all;

% show the 'solution', the labels of the symbols
for i=idx
   figure;
   imshow(reshape(X(i, :), [sizeImg, sizeImg]));
   label = y(i);
   symbol = getSymbol(symbolMap,label);
   if strcmp(symbol(1),'\\')==1
       symbolWS = symbol(2:end);
       title(sprintf('%i\n%s\n%s',i,symbol,symbolWS));
   else
       title(sprintf('%i\n%s',i,symbol));
   end
   set(gca,'fontsize',18);
end

pause;
close all;
end

%% Transform labels from 31:xx:1400 to 1:369
y = transformLabels(y, symbolMap{1});

%% Plot class distribution in X
plotAll = false;
if(~plotAll)
    display('No class distribution to plot - Skipping this section');
else
    plotClassDistribution(X,y);
end


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

%% Plot variance
if(~plotAll)
    disp('No variance to plot - Skipping this section');
else
    plotVariance(explained);
end

%% Split train-test!
trainRatio = 0.6;
[XtrainFull, ytrain, XtestFull, ytest] = splitData(Xpca, ycut, trainRatio);

%% nDim
oldclock = clock;
close all;
nDimList = [4, 8, 16, 32, 64, 128];
mse = zeros(size(nDimList,2),5);
time = zeros(size(nDimList,2),5);
mdlLabels = {'knn','bayes', 'tree', 'lda', 'svm'};

for i=1:length(nDimList)
% Reduce dimension
nDim = nDimList(i);

Xtrain = XtrainFull(:, 1:nDim);
Xtest = XtestFull(:, 1:nDim);

disp(['New dimension is nDim=', num2str(nDim)]);

tic
[mse(i,1), ~, ~, time(i,1)] = modelError('knn', Xtrain, ytrain, Xtest, ytest);


% Optimize KNN
% knnOpt = fitcknn(Xtrain,ytrain,...
%     'OptimizeHyperparameters','auto',...
%     'HyperparameterOptimizationOptions',...
%     struct('AcquisitionFunctionName','expected-improvement-plus'));

% Bayes
[mse(i,2), ~, ~, time(i,2)] = modelError('bayes', Xtrain, ytrain, Xtest, ytest);

% Tree
[mse(i,3), ~, ~, time(i,3)] = modelError('tree', Xtrain, ytrain, Xtest, ytest);

% Linear discriminant
[mse(i,4), ~, ~, time(i,4)] = modelError('lda', Xtrain, ytrain, Xtest, ytest);

% Binary SVMs
%[mse(i,5), mdlSvm] = modelError('svm', Xtrain, ytrain, Xtest, ytest);
%time(i,5) = toc; %- time(i,4);
end

disp(' End prediction');

plotModelsData(nDimList, mse, mdlLabels, 'Comparison of misclassification rate between models', 'Misclassification rate');
plotModelsData(nDimList, time, mdlLabels, 'Comparison of time efficiency between models', 'Runtime');

disp(['Total runtime is ', num2str(clock - oldclock)]);