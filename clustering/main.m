%% Name: Johnson Loh, Student No.: 9836543

clear; clc; close all;

%% read data

img = imread('eq1.png');
gray = rgb2gray(img);
% otsu thresholding & 1 for black pixel
BW = 1 - imbinarize(gray);

%% convert binary image into data array

% data format x1 x2
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
%plot(data(:,2),data(:,1),'bx');

%% agglomerative clustering

% TODO: autogenerate number of cluster centres

% create agglomerative hierarchical cluster tree
Z = linkage(data,'single','euclidean');
c = cluster(Z,'maxclust',16);

%% visualize clusters
scatter(data(:,2),data(:,1),16,c)
for ii = unique(c)'
    figure
    hold on
    scatter(data(c==ii,2),data(c==ii,1));
    scatter(mean(data(c==ii,2)),mean(data(c==ii,1)),'LineWidth',1.5,'MarkerFaceColor',[0 .7 .7])
    axis([0 size(BW,2) 0 size(BW,1)]);
end

% %% EM Gaussian Mixture Model
% 
% obj = fitgmdist(data,16);
% idx = cluster(obj,data);
% scatter(data(:,2),data(:,1),10,idx)
% 
% %% k-means clustering
% 
% [idx,C] = kmeans(data,16,'Distance','cityblock');
% scatter(data(:,2),data(:,1),16,idx)

%% generate output

% find bounding box values & cluster centres
corner1 = zeros(size(unique(c),1),2);
corner2 = zeros(size(unique(c),1),2);
means = zeros(size(unique(c),1),2);
for ii = unique(c)'
    corner1(ii,:) = min(data(c==ii,:));
    corner2(ii,:) = max(data(c==ii,:));
    means(ii,:) = mean(data(c==ii,:));
end