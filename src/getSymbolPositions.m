function [ listBB ] = getSymbolPositions( image,cutoff_flag,cutoff_var)
%getSymbolPositions
%       Returns a list of bounding boxes, described by 4-dim vectors
%               (min x, max x, min y, max y)

if nargin<2
    cutoff_flag = 0;
    cutoff_var = 0;
end

image = uint8(image);
%% read data
gray = rgb2gray(image);

% otsu thresholding & 1 for black pixel
BW = 1 - imbinarize(gray);

% check that clustering can actually handle this
nbrpixels = sum(sum(BW));
assert(nbrpixels<4000);

%% data conversion parameters
x_scale = 1;
y_scale = 1;

%% convert binary image into data array

% data format x1 x2
data = zeros(1,2);
index = 0;
for ii = 1:size(BW,1)
    for jj = 1:size(BW,2)
        if BW(ii,jj) == 1
            index = index + 1;
            data(index,1) = ii/y_scale;
            data(index,2) = jj/x_scale;
        end
    end
end

% visualize data
%plot(data(:,2),data(:,1),'bx');

%% agglomerative clustering

% TODO: autogenerate number of cluster centres

% create agglomerative hierarchical cluster tree
Z = linkage(data,'single','euclidean');
if cutoff_flag == 'maxclust'
    c = cluster(Z,'maxclust',cutoff_var);
else
    c = cluster(Z,'cutoff',1.9,'criterion','distance');
end

% %% EM Gaussian Mixture Model
%
% obj = fitgmdist(data,16);
% c = cluster(obj,data);
%
% %% k-means clustering
%
% [c,C] = kmeans(data,16,'Distance','cityblock');

% visualize data
figure;
hold on;
for ii = unique(c)'
    plot(data(c==ii,2),data(c==ii,1),'x');
end

%% generate output

% find bounding box values & cluster centres
% TODO: remove corner array for efficiency in function
corner1 = zeros(size(unique(c),1),2);
corner2 = zeros(size(unique(c),1),2);
means = zeros(size(unique(c),1),2);
listBB = zeros(size(unique(c),1),4);
bb = listBB;
for ii = unique(c)'
    corner1(ii,:) = min(data(c==ii,:)).*[y_scale x_scale];
    corner2(ii,:) = max(data(c==ii,:)).*[y_scale x_scale];
    means(ii,:) = mean(data(c==ii,:)).*[y_scale x_scale];
    if size(data(c==ii,:),1)==1
        corner1(ii,:) = data(c==ii,1);
        corner2(ii,:) = data(c==ii,1);
        means(ii,:) = data(c==ii,1);
    end
    %listBB(ii,:) = [corner1(ii,2),corner1(ii,1),corner2(ii,2)-corner1(ii,2),corner2(ii,1)-corner1(ii,1)];
    bb(ii,:) = [corner1(ii,2),corner1(ii,1),corner2(ii,2),corner2(ii,1)];
    listBB(ii,:) = [corner1(ii,1),corner2(ii,1),corner1(ii,2),corner2(ii,2)];
end

listBB = listBB';

%% visualize clusters
% factor = 1000/size(img,2);
% figure('Position', [300,300,factor*size(img,2),factor*size(img,1)]);
% scatter(data(:,2),data(:,1),16,c);
% set(gca,'Ydir','reverse');
% hold on
% for ii = unique(c)'
%     scatter(means(ii,2),means(ii,1),'LineWidth',1.5,'MarkerFaceColor',[0 .7 .7])
%     rectangle('Position', bb(ii,:),'EdgeColor','r','LineWidth',2 )
% end

%% ouput image

% out = img;
% shapeInserter = vision.ShapeInserter('BorderColor','Custom',...
% 'CustomBorderColor', uint8([255 0 0]));
% hold on
% for ii = unique(c)'
%     rectangle = int32(bb(ii,:));
%     out = shapeInserter(out, rectangle);
% end
% imshow(out)

end
