%% Name: Johnson Loh, Student No.: 9836543

clear; clc; close all;

%% read data

img = imread('eq1.png');
gray = rgb2gray(img);
% otsu thresholding & 1 for black pixel
BW = 1 - imbinarize(gray);

%% convert binary image into data array

% data format x1 x2 y
data = zeros(1,2);
index = 0;
for ii = 1:size(BW,1)
    for jj = 1:size(BW,2)
        if BW(ii,jj) == 1
            index = index + 1;
            data(index,1) = size(BW,1) - ii + 1;
            data(index,2) = jj;
        end
    end
end

% visualize data
plot(data(:,2),data(:,1),'bx');

%%