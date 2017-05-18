function [ probVector ] = getRecognition( symbolImage )
%getRecognition Summary of this function goes here
%   Detailed explanation goes here
%       Return a probability vector containing probabilities for each label

persistent net
persistent COEFF
persistent mu

if isempty(net)
    disp('Loading network data');
    load('../data/models/net35_ingredients.mat');
end

symbolImage = reshape(symbolImage, [1 1024]);
symbolImage = (symbolImage-mu)*COEFF;
probVector = net(symbolImage');

end