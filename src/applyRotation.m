function [ out_image ] = applyRotation( in_image, angle )
%APPLYROTATION Summary of this function goes here
%   Detailed explanation goes here

    in_image_frame = ones(size(in_image));
    out_image = uint8(1-imrotate(in_image_frame,90+angle));
    sz = size(out_image);
    out_image = out_image .* repmat(uint8(mean(mean(in_image))),[sz(1:2), 1]);
    out_image = out_image + imrotate(in_image,90+angle);

end

