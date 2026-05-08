function summary = RunSlidingMinMaxPipeline(inputDir, outputDir, opts)
%RUNSLIDINGMINMAXPIPELINE Pre-processes image pairs using sliding min and local min-max normalization.
%
% summary = RunSlidingMinMaxPipeline(inputDir, outputDir, opts)
%
% Inputs:
%   inputDir  - Folder containing raw images.
%   outputDir - Output folder. If empty, uses inputDir/Pre_Processed.
%   opts      - Struct with optional fields:
%               windowSize (default 8)
%               normWindow (default 4)
%               fileExt (default '*.tif')
%               maxImages (default inf)
%
% Output:
%   summary   - Struct with processing metadata.
%
% OIST - 2026
% see also: SlidingMinFilter, MinMaxNormalization

if nargin < 1 || isempty(inputDir)
    error('RunSlidingMinMaxPipeline:InputRequired','inputDir is required.');
end
if nargin < 2 || isempty(outputDir)
    outputDir = fullfile(inputDir, 'Pre_Processed');
end
if nargin < 3
    opts = struct();
end

if ~isfolder(inputDir)
    error('RunSlidingMinMaxPipeline:InvalidInputDir','Input directory does not exist: %s', inputDir);
end

if ~isfield(opts, 'windowSize'); opts.windowSize = 8; end
if ~isfield(opts, 'normWindow'); opts.normWindow = 4; end
if ~isfield(opts, 'fileExt'); opts.fileExt = '*.tif'; end
if ~isfield(opts, 'maxImages'); opts.maxImages = inf; end

validateattributes(opts.windowSize, {'numeric'}, {'scalar','integer','positive'}, mfilename, 'opts.windowSize');
validateattributes(opts.normWindow, {'numeric'}, {'scalar','integer','positive'}, mfilename, 'opts.normWindow');
validateattributes(opts.maxImages, {'numeric'}, {'scalar','positive'}, mfilename, 'opts.maxImages');
validateattributes(opts.fileExt, {'char','string'}, {'nonempty'}, mfilename, 'opts.fileExt');

thisDir = fileparts(mfilename('fullpath'));
addpath(genpath(fullfile(thisDir, '..', 'functions')));

if ~isfolder(outputDir)
    mkdir(outputDir);
end

files = dir(fullfile(inputDir, char(opts.fileExt)));
if isempty(files)
    error('RunSlidingMinMaxPipeline:NoFiles','No files found in %s with extension %s', inputDir, char(opts.fileExt));
end

N = min(numel(files), floor(opts.maxImages));
if mod(N,2) ~= 0
    N = N - 1;
end
if N < 2
    error('RunSlidingMinMaxPipeline:InsufficientPairs','Need at least 2 images to process pairs.');
end

for n = 1:2:N-1
    A = imread(fullfile(inputDir, files(n).name));
    B = imread(fullfile(inputDir, files(n+1).name));

    Asmin = SlidingMinFilter(A, opts.windowSize);
    Bsmin = SlidingMinFilter(B, opts.windowSize);

    Aa = double(A) - double(Asmin);
    Bb = double(B) - double(Bsmin);

    Anorm = MinMaxNormalization(Aa, opts.normWindow);
    Bnorm = MinMaxNormalization(Bb, opts.normWindow);

    imwrite(Anorm, fullfile(outputDir, ['Pre_' files(n).name]), 'Compression', 'none');
    imwrite(Bnorm, fullfile(outputDir, ['Pre_' files(n+1).name]), 'Compression', 'none');
end

summary = struct('inputDir', inputDir, 'outputDir', outputDir, 'processedImages', N);
