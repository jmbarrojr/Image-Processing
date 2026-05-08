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

Win = input('Type your window size(pixel based) : ');
path = uigetdir('', 'Select the directory where the images are');

filesLA = dir(fullfile(path, '*LA*.TIF'));
filesLB = dir(fullfile(path, '*LB*.TIF'));
filesRA = dir(fullfile(path, '*RA*.TIF'));
filesRB = dir(fullfile(path, '*RB*.TIF'));

FolResults = fullfile(path, 'Pre_Processed');
mkdir(FolResults);

pool = gcp('nocreate');
if ~isempty(pool)
    delete(pool);
end
parpool;
pool = gcp('nocreate');
cores = pool.NumWorkers;

tstart_p = tic;
disp('Calculating background subtraction')

N = min([numel(filesLA), numel(filesLB), numel(filesRA), numel(filesRB)]);
for n = 1:N
    ImgA = filesLA(n).name;
    ImgB = filesLB(n).name;
    A = imread(fullfile(path, ImgA));
    B = imread(fullfile(path, ImgB));
    [Sub_rA, Sub_rB] = BackgroundSubtractNormalize(A, B, Win, 'Method', 'minmax');
    imwrite(Sub_rA, fullfile(FolResults, ['Norm_' ImgA]), 'TIFF', 'Compression', 'none')
    imwrite(Sub_rB, fullfile(FolResults, ['Norm_' ImgB]), 'TIFF', 'Compression', 'none')

    ImgA = filesRA(n).name;
    ImgB = filesRB(n).name;
    A = imread(fullfile(path, ImgA));
    B = imread(fullfile(path, ImgB));
    [Sub_rA, Sub_rB] = BackgroundSubtractNormalize(A, B, Win, 'Method', 'minmax');
    imwrite(Sub_rA, fullfile(FolResults, ['Norm_' ImgA]), 'TIFF', 'Compression', 'none')
    imwrite(Sub_rB, fullfile(FolResults, ['Norm_' ImgB]), 'TIFF', 'Compression', 'none')

    disp('Working')
end

tstop_p = toc(tstart_p);
disp('DONE')
disp([num2str(tstop_p/60) ' minutes taken'])
disp(['Workers used: ' num2str(cores)])

pool = gcp('nocreate');
if ~isempty(pool)
    delete(pool);
end
