function summary = RunBackgroundSubtraction(inputDir, outputDir, opts)
%RUNBACKGROUNDSUBTRACTION Background subtraction pipeline for image pairs.
%
% summary = RunBackgroundSubtraction(inputDir, outputDir, opts)
%
% Inputs:
%   inputDir  - Folder with image files in pair order.
%   outputDir - Output folder. If empty, uses inputDir/Pre_Processed.
%   opts      - Struct with optional fields:
%               windowSize (default 16)
%               fileExt (default '*.TIF')
%               method (default 'median')
%               backNoise (default [])
%               bitDepth (default auto)
%
% OIST - 2026
% see also: BackgroundSubtractNormalize

if nargin < 1 || isempty(inputDir)
    error('RunBackgroundSubtraction:InputRequired','inputDir is required.');
end
if nargin < 2 || isempty(outputDir)
    outputDir = fullfile(inputDir, 'Pre_Processed');
end
if nargin < 3
    opts = struct();
end

if ~isfield(opts, 'windowSize'); opts.windowSize = 16; end
if ~isfield(opts, 'fileExt'); opts.fileExt = '*.TIF'; end
if ~isfield(opts, 'method'); opts.method = 'median'; end
if ~isfield(opts, 'backNoise'); opts.backNoise = []; end
if ~isfield(opts, 'bitDepth'); opts.bitDepth = []; end

thisDir = fileparts(mfilename('fullpath'));
addpath(genpath(fullfile(thisDir, '..', 'functions')));

if ~isfolder(outputDir)
    mkdir(outputDir);
end

files = dir(fullfile(inputDir, opts.fileExt));
N = numel(files);
if mod(N,2) ~= 0
    N = N - 1;
end

for i = 1:2:N
    ImgA = files(i).name;
    ImgB = files(i+1).name;

    A = imread(fullfile(inputDir, ImgA));
    B = imread(fullfile(inputDir, ImgB));

    [SubA, SubB] = BackgroundSubtractNormalize(A, B, opts.windowSize, ...
        'Method', opts.method, 'BackgroundNoise', opts.backNoise, 'BitDepth', opts.bitDepth);

    imwrite(SubA, fullfile(outputDir, ['SubNorm_' ImgA]), 'TIFF', 'Compression', 'none');
    imwrite(SubB, fullfile(outputDir, ['SubNorm_' ImgB]), 'TIFF', 'Compression', 'none');
end

summary = struct('inputDir', inputDir, 'outputDir', outputDir, 'processedImages', N);
