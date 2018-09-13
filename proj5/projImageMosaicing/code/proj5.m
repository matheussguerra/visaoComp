

% addpath /home/frankhelbert/Downloads/vlfeat-0.9.21/toolbox
addpath /home/guerra/Downloads/vlfeat-0.9.19/vlfeat-0.9.19/toolbox
vl_setup
pkg load statistics

% Clear up
clc;
close all;

% Parameters
randFlag = false;        % Whether images in random order
verbose  = true;         % Whether show stitching details

dataset = "lab";
%dataset = "church";
%dataset = "balcony";
%dataset = "guerra";

% Path
p         = mfilename('fullpath');
scriptDir = fileparts(p);
rootDir = fileparts(scriptDir);
inputDir  = fullfile(rootDir, 'data/', dataset);
inputFile = fullfile(inputDir, 'images.mat');
outputDir = fullfile(rootDir, 'results/');

% Load Images
if ~exist(inputFile, 'file')
    cd(inputDir);
    imgInfo = dir();
    imgInfo([imgInfo.isdir]) = []; 
    imgNum  = numel(imgInfo);
    images  = cell(imgNum, 1);
    for i = 1 : imgNum
        images{i} = imread(imgInfo(i).name);
         images{i} = imresize(images{i}, 1/5); % uncommend and change the following lines to produce adequate inputs
%         images{i} = imrotate(images{i}, -90);
%         images{i} = flipdim(images{i}, 2);
%         images{i} = flipdim(images{i}, 1);
    end
    cd(scriptDir);
    save(inputFile, 'images');
else
    load(inputFile);
end

% Mosaicing
imgMosaic = mymosaic(images, randFlag, verbose);
h = figure(3);
imshow(imgMosaic); axis image off;
title('Final Result of Mosaic');
% fig_save(h, fullfile(outputDir,'Mosaic'), 'png');
imwrite(imgMosaic, fullfile(outputDir,'Mosaic.png'), 'png');
