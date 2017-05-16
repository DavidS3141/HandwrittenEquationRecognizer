%% Clear 
clear;
close all;
clc;

%% 
disp('Do you want to run the next part?');
pause;
%% 
relPath = '../archives/HASYv2/hasy-data/';
imPrefix = 'v2-';
imSuffix = '.png';

nImg = 168233;
A = zeros(32, 32, nImg);

disp('Begin reading...');

for i=0:nImg-1
    if(i < 1e5)
        imgPath = [relPath, imPrefix, num2str(i, '%05d'), imSuffix];
        img = imread(imgPath);
        A(:, :, i+1) = rgb2gray(img);    
    else 
        imgPath = [relPath, imPrefix, num2str(i, '%06d'), imSuffix];
        img = imread(imgPath);
        A(:, :, i+1) = rgb2gray(img);  
    end
    
    if mod(i, 1000)==0
        disp(['   Iteration is ', num2str(i), '...']);
    end
end


disp('Reading over.');
disp('Now writing...');

save('imgData.mat', 'A');

disp('Writing over.');

a = logical(A);

save('imgData_logical.mat', 'a');

