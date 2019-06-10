%% Background subtraction
% Function to subtract background using local median & max intensity
%
% Author: Taehoon Kim & Julio Barros - UIUC 2014
% version: 1.0

clear
close all
clc

%%%%%%%%%%%%%%%
% USER INPUTS %
%%%%%%%%%%%%%%%

% Define window size
type = input('Type your window size(pixel based) : ');
Win = type;

if ispc == 1
    slash = '\';
else
    slash = '/';
end

path = uigetdir('','Select the directory where the images are');
%ext = '*.TIF';

files = dir([path slash '*L*.TIF']);

% make folder for normalized files
FolResults = [path slash 'Pre_Processed'];
mkdir(FolResults);

N = length(files);
N = 200;

tstart_p = tic; % Start computing Time

disp('Calculating background subtraction')
parfor i = 1 : N/2
    n = 2*i - 1;
    
    disp([files(n).name ' & ' files(n+1).name])
    ImgA = files(n).name;
    ImgB = files(n+1).name;
    
    LA = imread([path slash ImgA]);
    LB = imread([path slash ImgB]);
    
    %[Sub_rLA,Sub_rLB] = BackgroundSubNormalization(LA,LB,Win);
    [Sub_rLA,Sub_rLB] = BackSubNorm2010(LA,LB,Win,1);
    
    % save back to image files
    imwrite(Sub_rLA,[FolResults slash 'SubNorm_' ImgA],'TIFF','Compression','none')
    imwrite(Sub_rLB,[FolResults slash 'SubNorm_' ImgB],'TIFF','Compression','none')
    
end

tstop_p = toc(tstart_p);
disp('DONE')
disp([num2str(tstop_p/60) ' minutes taken'])

%figure,colormap gray
%subplot(1,2,1),imagesc(LA),axis equal tight
%subplot(1,2,2),imagesc(Sub_rLA),axis equal tight