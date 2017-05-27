function [ img, labels, symbolMap ] = loadHASY()
% Reads HASY data from saved files at specified paths
%  img: image examples ([32x32] ~ 1024 features)
%  labels: corresponding labels (369 different)
%  symbolMap: maps a label to the corresponding LaTeX code

%% Loading images from .mat
imgPath = '../data/extract/HASYv2_logical.mat';
X = load(imgPath);
img = X.a;

%% Reading labels
labelsPath = '../data/extract/labels.mat';
lab = load(labelsPath);
labels = lab.labels;

%% Reading symbol table
symbolMapPath = '../data/extract/symbols.mat';
smap = load(symbolMapPath);
symbolMap = smap.symbolMap;

end

