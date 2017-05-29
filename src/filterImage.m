function [ filteredImage ] = filterImage( image )
%filterImage Summary of this function goes here
%   Detailed explanation goes here

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
    
    filteredImage = (image>0.5);
end

