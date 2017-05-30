function [ errorTest, model, ypred ] = modelError( modelName, Xtrain, ytrain, Xtest, ytest )
% Returns the error of a classification model trained
%  with respect to the input, on train set (Xtrain, ytrain)
%  and (Xtest, ytest)
% The output is the error on the test set and the model itself

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

ypred = model.predict(Xtest);
errorTest = mean(ypred ~= ytest);
disp(['  Prediction - Model:', modelName,', with error e=', num2str(errorTest)]);

end

