function [ probVector ] = getRecognition( symbolImage )
%getRecognition Summary of this function goes here
%   Detailed explanation goes here
%       Return a probability vector containing probabilities for each label

persistent net
persistent COEFF
persistent mu

if isempty(net)
    disp('Loading network data');
    load('../data/models/net_misclass31_indim36.mat');
end

symbolImage = reshape(symbolImage, [1 1024]);
% symbolImage = (symbolImage-mu)*COEFF;
imageList = reshape(symbolImage,[size(symbolImage,1),32,32]);
reducedSize = 6;
symbolImage = zeros(size(symbolImage,1),reducedSize^2);
for i=1:size(symbolImage,1)
   symbolImage(i,:)=reshape(imresize(reshape(imageList(i,:,:),[32 32]),[reducedSize reducedSize]),[1 reducedSize^2]);
end
probVector = net(symbolImage');

end