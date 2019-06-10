%% Background subtraction
clear all
close all
clc

path = 'J:\test_BackSubt\test_preprocessing\Hemi_xz_1.3k_10Hz\Analysis\test1\';

imgA = 'Hemi_xz_1-3k_10Hz001262.T000.D000.P000.H004_raw.LA.TIF';
imgB = 'Hemi_xz_1-3k_10Hz001262.T000.D000.P000.H004_raw.LB.TIF';

% read image files
A = double(imread([path imgA]));
B = double(imread([path imgB]));

% define window size
Win = 16;

%% Local normalization based on local median intensity 
min = SlidingMinFilter(A,Win);

Amed = SlidingMedianFilter(A,Win);
Amed = Amed + 1;
NmedA = (A - min) ./ (Amed - min);

Bmed = SlidingMedianFilter(B,Win);
Bmed = Bmed + 1;
NmedB = (B - min) ./ (Bmed - min);

%% Subtraction Frame A from Frame B
Sub = NmedA - NmedB;

%% Local normalization based on local max intensity

Sub_max = SlidingMaxFilter(Sub,Win);
% Sub_max2 = SlidingMaxFilter(A,Win);
% Sub_max = (Sub_max1 + Sub_max2)/2;
Sub_final = (Sub - min) ./ (Sub_max - min);
% 
% Sub_max2 = SlidingMaxFilter(Sub_final,Win);
% Sub_final2 = (Sub - min) ./ (Sub_max2 - min);

% Reconstruct Image for Frame A & B
index = Sub_final > 0;
Sub_rA = zeros(size(Sub_max));
Sub_rA(index) = Sub_final(index);

index = Sub_final < 0;
Sub_rB = zeros(size(Sub_max));
Sub_rB(index) = Sub_final(index);

Sub_rA = uint8(Sub_rA * 256);
Sub_rB = uint8(-1*Sub_rB * 256);

% save as image file
imwrite(Sub_rA,[path 'Norm_' imgA],'TIFF')
imwrite(Sub_rB,[path 'Norm_' imgB],'TIFF')