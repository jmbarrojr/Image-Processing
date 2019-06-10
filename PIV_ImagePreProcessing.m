%PIV_IMAGEPREPROCESSING
%
% Author: Julio Barros
% OIST - 2019

clc
clear

addpath(genpath(['.' filesep 'Support and Functions']))

path = uigetdir('Choose the direction which contains the images');

savepath = [path filesep 'Pre_Processed'];
if ~isfolder(savepath)
    mkdir(savepath)
end
    
files = dir([path filesep '*.tif']);
N = length(files);

Win = 16;
%% Main Loop
for n=1:2:N-1

    A = imread([path filesep files(n).name]);
    B = imread([path filesep files(n+1).name]);
    
    % [Sub_A,Sub_B] = BackgroundSubNormalization(A,B,Win);
    
    Sub_A = HighPass(A,7,1);
    Sub_B = HighPass(B,7,1);
    
    % Sub_A = MinMaxNormalization(Sub_A,Win);
    % Sub_B = MinMaxNormalization(Sub_B,Win);
    
    imwrite(Sub_A,[savepath filesep files(n).name],'Compression','none')
    imwrite(Sub_B,[savepath filesep files(n+1).name],'Compression','none')
    
end

figure(1), colormap gray
subplot(2,2,1),imagesc(A),axis equal tight
subplot(2,2,2),imagesc(B),axis equal tight
subplot(2,2,3),imagesc(Sub_A),axis equal tight
subplot(2,2,4),imagesc(Sub_B),axis equal tight
