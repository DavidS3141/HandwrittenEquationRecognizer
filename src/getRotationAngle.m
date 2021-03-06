function [ angle ] = getRotationAngle( image )
%getRotationAngle determines the angle by which the image needs to be rotated to show equations
%                       horizontially, as the symbol recognition moved into focus, this work was dropped

    % constants
    shade_blocks = 20;

    % turn to gray values from 0 to 1
    image = rgb2gray(image);
    image = double(image)/double(max(max(image)));
    % get size of the image
    sz = size(image);
    cells = sz(1)*sz(2);
    % subtract the overall shade of the image
    shade = imresize(image, sqrt(shade_blocks/cells));
    shade = imresize(shade, sz);
    image = image - shade;
    image = image - min(min(image));
    image = image / max(max(image));

    quadSize = [1:min(sz);1:min(sz)]+0.5*repmat((sz-min(sz))', 1, min(sz));
    quadImage = image(quadSize(1,:),quadSize(2,:));

    BW = 1-quadImage;
    BW = (BW > 0.7);

    rhoResolution = min(120, min(size(BW))/2);
    [H,T,~] = hough(BW,'RhoResolution',rhoResolution,'ThetaResolution',0.5);

    bestSTD = 0;
    for i=1:size(H,2)
        curCol = H(find(H(:,i),1,'first'):find(H(:,i),1,'last'),i);
        curSTD = std(curCol);
        if curSTD > bestSTD
            bestSTD = curSTD;
            angle = T(i);
        end
    end

end
