function [ listSymbols ] = HER( image )
%HER The total process of applying the HandwrittenEquationRecognizer on an image

persistent latexLabel
if isempty(latexLabel)
    load('../data/extract/latexLabel.mat');
end

%angle = getRotationAngle(image);
%image = applyRotation(image,angle);
filteredImage = imbinarize(rgb2gray(image));
%filteredImage = filterImage(image);
resultImage = ones(size(filteredImage)+[20 20]);
filteredImage = double(repmat(filteredImage,1,1,3));
figure;
imshow(filteredImage);
listBB = getSymbolPositions(filteredImage);%,'maxclust',16);

for BB = listBB
    if((BB(1)-BB(2))*(BB(3)-BB(4))<10)
        continue
    end
    symbolImage = image(BB(1):BB(2),BB(3):BB(4),:);
    symbolImage = rgb2gray(symbolImage);
    symbolImage = double(symbolImage) - double(min(min(symbolImage)));
    symbolImage = double(symbolImage)/double(max(max(symbolImage)));
    assert(min(min(symbolImage))==0);
    assert(max(max(symbolImage))==1);
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
    % symbolImage = imbinarize(symbolImage);
    prob = getRecognition(symbolImage);
    [bestp, besty] = max(prob);
    figure;
    imshow(symbolImage);
    title(sprintf('%f:%i\n%s',bestp,besty,latexLabel{besty}));
    lab = latexLabel{besty};
    oldlab = lab
    lab = ''
    for c=oldlab
        if c~='\'
            lab = [lab c];
        end
    end
    if lab(1)>='A' & lab(1)<='Z'
        lab(1) = char('a' + lab(1) - 'A');
    end
    if lab(1)=='|'
       lab = 'vert';
    end
    if lab(1)=='{'
       lab = 'lbrace';
    end
    if lab(1)=='-'
       lab = 'minus';
    end
    if lab(1)=='+'
       lab = 'plus';
    end
    if lab(1)=='$'
       lab = 'dollar';
    end
    if strcmp(lab,'mathscr{C}')
       lab = 'scrc';
    end
    if strcmp(lab,'mathcal{O}')
       lab = 'calo';
    end
    if strcmp(lab,'mathds{Z}')
       lab = 'bbz';
    end
    if strcmp(lab,'rightarrow')
       lab = 'longrightarrow';
    end
    if strcmp(lab,'mathbb{1}')
       lab = '1';
    end
    lab = [ '../data/symbols/' lab '.png' ]
    [labim, map, alpha] = imread(lab);
    [xs,ys] = size(labim);
    scale = ((BB(2)-BB(1))/xs + (BB(4)-BB(3))/ys)/2;
    labim = imresize(labim,scale);
    [xs,ys] = size(labim);
    mx = ceil((BB(1)+BB(2))/2);
    my = ceil((BB(3)+BB(4))/2);
    lx = mx - floor(xs/2);
    rx = mx + ceil(xs/2)-1;
    ly = my - floor(ys/2);
    ry = my + ceil(ys/2)-1;
    resultImage(lx+10:rx+10,ly+10:ry+10)=labim;
end

figure;
imshow(resultImage);

end
