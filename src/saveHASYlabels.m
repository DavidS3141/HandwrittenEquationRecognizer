%% Save HASY Images
% This script reads HASYv2 labels (from .csv file)
%  and saves them in a .mat file
% The symbols corresponding to the labels are extracted as well

%% Clear
clear all; clc; close all;

%% 
disp('Do you want to run the next part?');
pause;

%% Read labels
disp('Reading labels...');
labelsPath = '../data/extract/hasy-data-labels.csv';
labelFile = fopen(labelsPath);
labelStruct = textscan(labelFile, '%s %s %s %s', 'Delimiter', ',');
labels = cellfun(@str2double, labelStruct{2}(2:end));


%% Read symbol table
disp('Reading symbols...');
symbolFilePath = '../data/extract/symbols.csv';
symbolFile = fopen(symbolFilePath);
symbolMap = textscan(symbolFile, '%s %s %s %s', 'Delimiter', ',');


%% Write
save('../data/extract/labels.mat', 'labels');
save('../data/extract/symbols.mat', 'symbolMap');

disp('Writing over.');

