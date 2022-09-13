%% Background subtraction
% Function to subtract background using local median & max intensity
%
% Author: Taehoon Kim & Julio Barros - UIUC 2014
% version: 1.0

clear all
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

%%
filesLA = dir([path slash '*LA*.TIF']);
filesLB = dir([path slash '*LB*.TIF']);
filesRA = dir([path slash '*RA*.TIF']);
filesRB = dir([path slash '*RB*.TIF']);

% %%%%%%%%%%
% % DEBUG
% %%%%%%%%%%
% filesLA = filesLA(1:10,:);
% filesLB = filesLB(1:10,:);
% filesRA = filesRA(1:10,:);
% filesRB = filesRB(1:10,:);

% make folder for normalized files
FolResults = [path slash 'Pre_Processed'];
mkdir(FolResults);

%N = length(filesLA);
N = 10;

% Close if there is any open pool
if matlabpool('size') > 0;
    matlabpool close force local
end
% Start the Parallel pools
matlabpool open
cores = matlabpool('size'); % Number of cores availabe in the computer

%%
tstart_p = tic; % Start computing Time
disp('Calculating background subtraction')
for n = 1:N
    
    ImgA = filesLA(n).name;
    ImgB = filesLB(n).name;
    % Open Left Images
    A = double(imread([path slash ImgA]));
    B = double(imread([path slash ImgB]));
    % Backgroung and Normalized
    %[Sub_rA,Sub_rB] = BackgroundSubNormalization(A,B,Win);
    [Sub_rA,Sub_rB] = MinMaxNormalization(A,B,Win);
    % save back to image files
    imwrite(Sub_rA,[FolResults slash 'Norm_' ImgA],'TIFF','Compression','none')
    imwrite(Sub_rB,[FolResults slash 'Norm_' ImgB],'TIFF','Compression','none')
    
    ImgA = filesRA(n).name;
    ImgB = filesRB(n).name;
    % Open Left Images
    A = double(imread([path slash ImgA]));
    B = double(imread([path slash ImgB]));
    % Backgroung and Normalized
    %[Sub_rA,Sub_rB] = BackgroundSubNormalization(A,B,Win);
    [Sub_rA,Sub_rB] = MinMaxNormalization(A,B,Win);
    % save back to image files
    imwrite(Sub_rA,[FolResults slash 'Norm_' ImgA],'TIFF','Compression','none')
    imwrite(Sub_rB,[FolResults slash 'Norm_' ImgB],'TIFF','Compression','none')
    disp('Working')
     
end

tstop_p = toc(tstart_p);

disp('DONE')
disp([num2str(tstop_p/60) ' minutes taken'])

% Close Matlab Pool
matlabpool close