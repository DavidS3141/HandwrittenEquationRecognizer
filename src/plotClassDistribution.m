function [] = plotClassDistribution(X,y)
% Plots the class distribution in X, from the labels in y
%  Answers the following:
%  "If I consider nn classes in X, how many elements am I considering?"

figure;
hold on

X = X(:,1);

nClasses = unique(y)';
nClasses = nClasses(:, 1:5:end);

for i=nClasses
    plot(i, size(X(y<=i,:),1), 'ro');
    if(mod(i,10)==1)
        disp(['Plotting for i=', num2str(i)]);
    end
end