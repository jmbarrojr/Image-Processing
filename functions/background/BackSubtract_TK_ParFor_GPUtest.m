%% Background subtraction GPU/parfor test script (legacy)

clear
close all
clc

Win = input('Type your window size(pixel based) : ');
path = uigetdir('', 'Select the directory where the images are');

files = dir(fullfile(path, '*L*.TIF'));
FolResults = fullfile(path, 'Pre_Processed');
mkdir(FolResults);

N = min(length(files), 200);
backNoise = 1; % Legacy empirical noise floor for minmax-based subtraction

tstart_p = tic;
disp('Calculating background subtraction')

parfor i = 1 : floor(N/2)
    n = 2*i - 1;

    ImgA = files(n).name;
    ImgB = files(n+1).name;

    LA = imread(fullfile(path, ImgA));
    LB = imread(fullfile(path, ImgB));

    [Sub_rLA, Sub_rLB] = BackSubNorm2010(LA, LB, Win, backNoise);

    imwrite(Sub_rLA, fullfile(FolResults, ['SubNorm_' ImgA]), 'TIFF', 'Compression', 'none')
    imwrite(Sub_rLB, fullfile(FolResults, ['SubNorm_' ImgB]), 'TIFF', 'Compression', 'none')
end

tstop_p = toc(tstart_p);
disp('DONE')
disp([num2str(tstop_p/60) ' minutes taken'])
