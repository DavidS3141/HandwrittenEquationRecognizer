function [ out_image ] = applyRotation( in_image, angle )
%APPLYROTATION Summary of this function goes here
%   Detailed explanation goes here

    in_image_frame = ones(size(in_image));
    out_image = uint8(1-imrotate(in_image_frame,90+angle));
    out_image = out_image .* uint8(mean(mean(in_image)));
    out_image = out_image + imrotate(in_image,90+angle);

end

