function summary = RunAdaptiveBandPassPipeline(inputDir, outputDir, opts)
%RUNADAPTIVEBANDPASPIPELINE Applies CLAHE and optional band-pass filtering.
%
% summary = RunAdaptiveBandPassPipeline(inputDir, outputDir, opts)
%
% Inputs:
%   inputDir  - Folder containing raw images.
%   outputDir - Output folder. If empty, uses inputDir/Pre_Processed.
%   opts      - Struct with optional fields:
%               spotSize (default 32)
%               fileExt (default '*.TIF')
%               applyBandPass (default false)
%               lnoise (default 2)
%               lobject (default 3)
%               bitDepth (default auto: 8 for uint8, 12 for uint16)
%
% Output:
%   summary   - Struct with processing metadata.
%
% OIST - 2026
% see also: adapthisteq, bpass

if nargin < 1 || isempty(inputDir)
    error('RunAdaptiveBandPassPipeline:InputRequired','inputDir is required.');
end
if nargin < 2 || isempty(outputDir)
    outputDir = fullfile(inputDir, 'Pre_Processed');
end
if nargin < 3
    opts = struct();
end

if ~isfolder(inputDir)
    error('RunAdaptiveBandPassPipeline:InvalidInputDir','Input directory does not exist: %s', inputDir);
end

if ~isfield(opts, 'spotSize'); opts.spotSize = 32; end
if ~isfield(opts, 'fileExt'); opts.fileExt = '*.TIF'; end
if ~isfield(opts, 'applyBandPass'); opts.applyBandPass = false; end
if ~isfield(opts, 'lnoise'); opts.lnoise = 2; end
if ~isfield(opts, 'lobject'); opts.lobject = 3; end
if ~isfield(opts, 'bitDepth'); opts.bitDepth = []; end

validateattributes(opts.spotSize, {'numeric'}, {'scalar','integer','positive'}, mfilename, 'opts.spotSize');
validateattributes(opts.fileExt, {'char','string'}, {'nonempty'}, mfilename, 'opts.fileExt');
validateattributes(opts.applyBandPass, {'logical','numeric'}, {'scalar'}, mfilename, 'opts.applyBandPass');

thisDir = fileparts(mfilename('fullpath'));
addpath(genpath(fullfile(thisDir, '..', 'functions')));

if ~isfolder(outputDir)
    mkdir(outputDir);
end

files = dir(fullfile(inputDir, char(opts.fileExt)));
if isempty(files)
    error('RunAdaptiveBandPassPipeline:NoFiles','No files found in %s with extension %s', inputDir, char(opts.fileExt));
end

for n = 1:numel(files)
    ImgName = files(n).name;
    A = imread(fullfile(inputDir, ImgName));

    Aa = double(A) ./ max(double(A(:)), eps);
    [J, I] = size(A);
    winx = max(1, floor(I ./ opts.spotSize));
    winy = max(1, floor(J ./ opts.spotSize));

    B = adapthisteq(Aa, 'NumTiles', [winy winx], 'Range', 'original');

    if opts.applyBandPass
        B = bpass(B, opts.lnoise, opts.lobject);
        B = B ./ max(B(:), eps);
    end

    if isa(A, 'uint8')
        Imax = 255;
    else
        if isempty(opts.bitDepth)
            bitDepth = 12;
        else
            bitDepth = opts.bitDepth;
        end
        if bitDepth == 16
            Imax = 65535;
        else
            Imax = 4095;
        end
    end

    B = max(min(B, 1), 0);

    if isa(A, 'uint8')
        B = uint8(B .* Imax);
    else
        B = uint16(B .* Imax);
    end

    imwrite(B, fullfile(outputDir, ['Ad_' ImgName]), 'tif', 'Compression', 'none');
end

summary = struct('inputDir', inputDir, 'outputDir', outputDir, 'processedImages', numel(files));
