function [ ] = plotModelsData( nDimList, data, modelNames, titleS, ylabelS )
% Creates a plot of the inaccuracy rate of the models
%  given in the struct modelNames, on several runs with
%  dimensions described in nDimList
% The misclassification rate is stored in MSE, such that
%  each line corresponds to an index in nDimList
%  i.e. one column is one model

figure;
hold on;
grid on;
for j=1:size(data,2)
   plot(nDimList, data(:,j), 'o--', 'LineWidth', 2); 
end
title(titleS);
ylabel(ylabelS);
legend(modelNames);
axis([min(nDimList), max(nDimList)+0.1, 0, max(max(data))]); % +0.1 if nDimList is [x]

end

