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
N = 2000;

Win = 16;
%% Main Loop
for n=1:2:N-1

    A = imread([path filesep files(n).name]);
    B = imread([path filesep files(n+1).name]);
    
    %[Sub_A,Sub_B] = BackgroundSubNormalization(A,B,Win);
    
    %Ahigh = HighPass(A,7,1);
    %Bhigh = HighPass(B,7,1);
    
    %Sub_A = MinMaxNormalization(A,Win);
    %Sub_B = MinMaxNormalization(A,Win);
    
    Asmin = SlidingMinFilter(A,8);
    Bsmin = SlidingMinFilter(B,8);
    Aa = A - Asmin;
    Bb = B - Bsmin;
    
    %Aa = medfilt2(Sub_A,[2 2]);
    %Bb = medfilt2(Sub_B,[2 2]);
    
    Anorm = MinMaxNormalization(Aa,4);
    Bnorm = MinMaxNormalization(Bb,4);
    
    Afinal = Anorm;
    Bfinal = Bnorm;
    
    imwrite(Afinal,[savepath filesep 'Pre_' files(n).name],'Compression','none')
    imwrite(Bfinal,[savepath filesep 'Pre_' files(n+1).name],'Compression','none')
    
end

figure(1), colormap gray
subplot(2,2,1),imagesc(A),axis equal tight
subplot(2,2,2),imagesc(B),axis equal tight
subplot(2,2,3),imagesc(Afinal),axis equal tight
subplot(2,2,4),imagesc(Bfinal),axis equal tight
