function [ errorTest, model, ypred, timeTrain, timePredict ] = modelError( modelName, Xtrain, ytrain, Xtest, ytest )
% Returns the error of a classification model trained
%  with respect to the input, on train set (Xtrain, ytrain)
%  and (Xtest, ytest)
% The output is the error on the test set and the model itself

tic
switch modelName
    case 'svm'
        model = fitcecoc(Xtrain, ytrain);
    case 'lda'
        model = fitcdiscr(Xtrain, ytrain);
    case 'tree'
        model = fitctree(Xtrain, ytrain);
    case 'bayes'
        model = fitcnb(Xtrain, ytrain);
    otherwise 
        model = fitcknn(Xtrain, ytrain);
end

timeTrain = toc;
ypred = model.predict(Xtest);
errorTest = mean(ypred ~= ytest);
timePredict = toc - timeTrain;
disp(['  Prediction',...
     '- Model:', modelName,...
     ', with error e=', num2str(errorTest),...
     ' - and time t=', num2str(timeTrain+timePredict)]);

end

