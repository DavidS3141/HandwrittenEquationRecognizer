%% Clear
clear all; clc; close all;

%% 
disp('Do you want to run the next part?');
pause;

%% Read images
relPath = '../data/archives/HASYv2/hasy-data/';
imPrefix = 'v2-';
imSuffix = '.png';

nImg = 168233;
X = zeros(32, 32, nImg);

disp('Begin reading images...');

for i=0:nImg-1
    if(i < 1e5)
        imgPath = [relPath, imPrefix, num2str(i, '%05d'), imSuffix];
        img = imread(imgPath);
        X(:, :, i+1) = rgb2gray(img);    
    else 
        imgPath = [relPath, imPrefix, num2str(i, '%06d'), imSuffix];
        img = imread(imgPath);
        X(:, :, i+1) = rgb2gray(img);  
    end
    
    if mod(i, 1000)==0
        disp(['   Iteration is ', num2str(i), '...']);
    end
end
disp('Reading images over.');

%% Writing as .mat
disp('Now writing...');

save('imgData.mat', 'X');

disp('Writing over.');

xLogical = logical(X);

save('imgData_logical.mat', 'x');

