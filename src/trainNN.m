clear;
close all;

%% load data
load('../data/extract/trainData.mat');

%% Train neural network

ynn = y;
Xnn = X;

'Reduce input size'
imageList = reshape(Xnn,[size(Xnn,1),32,32]);
Xnn = zeros(size(Xnn,1),64);
for i=1:size(Xnn,1)
    Xnn(i,:)=reshape(imresize(reshape(imageList(i,:,:),[32 32]),[8 8]),[1 64]);
end

ynn = [1:max(ynn)] == ynn;

setdemorandstream(pi);

net = feedforwardnet(25);

net.divideFcn = '';
'Start training'
net = train(net,Xnn',ynn',nnMATLAB);