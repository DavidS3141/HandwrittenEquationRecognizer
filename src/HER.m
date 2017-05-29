function [ listSymbols ] = HER( image )
%HER Summary of this function goes here
%   Detailed explanation goes here

persistent latexLabel
if isempty(latexLabel)
    load('../data/extract/latexLabel.mat');
end

angle = getRotationAngle(image);
image = applyRotation(image,angle);
filteredImage = filterImage(image);
filteredImage = double(repmat(filteredImage,1,1,3));
imshow(filteredImage);
listBB = getSymbolPositions(filteredImage,'maxclust',16);
size(image)

for BB = listBB
    disp(BB);
    symbolImage = image(BB(1):BB(2),BB(3):BB(4),:);
    symbolImage = rgb2gray(symbolImage);
    symbolImage = double(symbolImage)/double(max(max(symbolImage)));
    sizeOfImage = max(size(symbolImage));
    addRows = sizeOfImage - size(symbolImage,1);
    addCols = sizeOfImage - size(symbolImage,2);
    symbolImage = [ ones(floor(addRows/2),size(symbolImage,2)) ; symbolImage];
    symbolImage = [ symbolImage; ones(ceil(addRows/2),size(symbolImage,2))];
    symbolImage = [ ones(size(symbolImage,1),floor(addCols/2)) , symbolImage];
    symbolImage = [ symbolImage, ones(size(symbolImage,1),ceil(addCols/2))];
    assert(size(symbolImage,1)==size(symbolImage,2));
    symbolImage = imresize(symbolImage, [32 32]);
    % tresh = prctile(symbolImage(:),16.5); %perform this over all symbols simultaneously
    % symbolImage = (symbolImage >= tresh);
    prob = getRecognition(symbolImage);
    [bestp, besty] = max(prob);
    figure;
    imshow(symbolImage);
    title(sprintf('%f:%i\n%s',bestp,besty,latexLabel{besty}));
end

end
