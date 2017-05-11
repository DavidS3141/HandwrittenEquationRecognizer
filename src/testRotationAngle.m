clear;
close all;

for i=1:7
    numStr = sprintf('%i', i);
    if i<10
        numStr = sprintf('0%i', i);
    end
    % load image
    image = imread(sprintf('../data/test/%s.jpg',numStr));
    angle = getRotationAngle(image);
    result = applyRotation(image,angle);
    figure;
    imshow(result);
end

return;
%%
% constants
shade_blocks = 20;

% load image
image = imread('../data/test/07.jpg');
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

figure;
imshow(image);

%%

quadSize = [1:min(sz);1:min(sz)]+0.5*repmat((sz-min(sz))', 1, min(sz));
curimage = image(quadSize(1,:),quadSize(2,:));

BW = edge(curimage,'canny');
BW = 1-curimage;
BW = (BW > 0.7);

[H,T,R] = hough(BW,'RhoResolution',120,'ThetaResolution',0.5);

%subplot(2,1,1);
figure;
imshow(BW);
title('gantrycrane.png');
figure;
imshow(imadjust(mat2gray(H)),'XData',T,'YData',R,...
      'InitialMagnification','fit');
title('Hough transform of gantrycrane.png');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;
colormap(gca,hot);

P  = houghpeaks(H,1);
%imshow(H,[],'XData',T,'YData',R,'InitialMagnification','fit');
%xlabel('\theta'), ylabel('\rho');
%axis on, axis normal, hold on;
%plot(T(P(:,2)),R(P(:,1)),'s','color','black','LineWidth',10);

angle = T(P(:,2));

bestSTD = 0;
idx = 1;
for i=1:size(H,2)
    curCol = H(find(H(:,i),1,'first'):find(H(:,i),1,'last'),i);
    curSTD = std(curCol);
    if curSTD > bestSTD
        bestSTD = curSTD;
        idx = i;
    end
end

angle = T(idx);

[~, pos] = max(H(:,idx));
plot(angle, R(pos) ,'s','color','black','LineWidth',10);

testresult = 1-imrotate(1-image,90+angle);
figure;
imshow(testresult);
return;
%%

% ori_blocks = 5;
% cells_block = cells / ori_blocks;
% block_length = floor(sqrt(cells_block));
% xdiv = sz(1)/block_length;
% ydiv = sz(2)/block_length;
% bimage = image;
% xcoos = floor(((0:floor(xdiv)) + 0.5*(xdiv-floor(xdiv)))*block_length);
% ycoos = floor(((0:floor(ydiv)) + 0.5*(ydiv-floor(ydiv)))*block_length);
% for x=xcoos
%     for y=1:sz(2)
%         for d=-5:5
%             bimage(x+d,y)=0.;
%         end
%     end
% end
% for x=1:sz(1)
%     for y=ycoos
%         for d=-5:5
%             bimage(x,y+d)=0.;
%         end
%     end
% end
% figure;
% imshow(bimage);
% return;

percentile = 1000/cells;
%percentile = 0.01;
tresh = prctile(image(:),percentile*100);
bitmap = (image <= tresh);
figure;
imshow(bitmap);

X = [];
counter = 0;
for x=1:sz(1)
    for y=1:sz(2)
        if bitmap(x,y)
            counter = counter + 1;
            X(counter,1) = x;
            X(counter,2) = y;
        end
    end
end

[PCA,score,latent] = princomp(X);
xPCA = PCA(1,1);
yPCA = PCA(2,1);
angle = atan2(yPCA,xPCA)/2/pi*360;

testresult = 1-imrotate(1-image,90-angle);
figure;
imshow(testresult);