%% Background subtraction
% Function to subtract background using local median & max intensity
%
% Author: Taehoon Kim & Julio Barros - UIUC 2014
% version: 1.0

clear all
close all
clc

Win = input('Type your window size(pixel based) : ');
path = uigetdir('', 'Select the directory where the images are');

filesLA = dir(fullfile(path, '*.LA.TIF'));
filesLB = dir(fullfile(path, '*.LB.TIF'));
filesRA = dir(fullfile(path, '*.RA.TIF'));
filesRB = dir(fullfile(path, '*.RB.TIF'));

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

CompVecListLA = DistVecContent(cores, filesLA);
CompVecListLB = DistVecContent(cores, filesLB);
CompVecListRA = DistVecContent(cores, filesRA);
CompVecListRB = DistVecContent(cores, filesRB);

disp('Calculating background subtraction')

spmd
    Np = length(CompVecListLA);

    for n = 1:Np
        ImgLA = CompVecListLA(n).name;
        ImgLB = CompVecListLB(n).name;
        ImgRA = CompVecListRA(n).name;
        ImgRB = CompVecListRB(n).name;

        LA = imread(fullfile(path, ImgLA));
        LB = imread(fullfile(path, ImgLB));
        RA = imread(fullfile(path, ImgRA));
        RB = imread(fullfile(path, ImgRB));

        [Sub_rLA, Sub_rLB] = BackgroundSubNormalization(LA, LB, Win);
        [Sub_rRA, Sub_rRB] = BackgroundSubNormalization(RA, RB, Win);

        imwrite(Sub_rLA, fullfile(FolResults, ['Norm_' ImgLA]), 'TIFF', 'Compression', 'none')
        imwrite(Sub_rLB, fullfile(FolResults, ['Norm_' ImgLB]), 'TIFF', 'Compression', 'none')
        imwrite(Sub_rRA, fullfile(FolResults, ['Norm_' ImgRA]), 'TIFF', 'Compression', 'none')
        imwrite(Sub_rRB, fullfile(FolResults, ['Norm_' ImgRB]), 'TIFF', 'Compression', 'none')
    end
end

tstop_p = toc(tstart_p);

disp('DONE')
disp([num2str(tstop_p/60) ' minutes taken'])

pool = gcp('nocreate');
if ~isempty(pool)
    delete(pool);
end
