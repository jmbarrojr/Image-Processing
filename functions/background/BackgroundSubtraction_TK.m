%% Background subtraction (legacy demo script)
% Author: Taehoon Kim & Julio Barros - UIUC 2014
% Modernized for cross-platform directory selection.

clear all
close all
clc

path = uigetdir('', 'Select the directory where the images are');
if isequal(path, 0)
    error('No input directory selected.');
end

imgA = input('Enter LA image filename: ', 's');
imgB = input('Enter LB image filename: ', 's');
Win = input('Type your window size(pixel based) : ');

A = imread(fullfile(path, imgA));
B = imread(fullfile(path, imgB));

[subRA, subRB] = BackgroundSubNormalization(A, B, Win);

imwrite(subRA, fullfile(path, ['Norm_' imgA]), 'TIFF', 'Compression', 'none')
imwrite(subRB, fullfile(path, ['Norm_' imgB]), 'TIFF', 'Compression', 'none')
