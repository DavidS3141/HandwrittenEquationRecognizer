function [  ] = plotVariance( explainedVariance )
% Plots the variance explained by the number of
%  vectors chosen from a PCA decomposition

nPts = 20;
nExamples = size(explainedVariance, 1);
ii = round(logspace(0, log10(nExamples), nPts));
var = zeros(nPts, 1);

for i=1:nPts
    var(i) = sum(explainedVariance(1:ii(i)));
end

ii = [0 ii];
var = [0; var];

figure;
plot(ii, var, 'o--', 'LineWidth', 2);
title('Amount of variance explained by the principal components');
xlabel('Principal components');
ylabel('Sum of the variance over the components');
axis([0 max(ii) 0 100]);

end

