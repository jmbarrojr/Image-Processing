%PIV_ImagePreProcessing_AdaptiveBandPass Legacy wrapper for adaptive band-pass workflow.
%
% Use PIVPreProcess.m for the unified interactive workflow.

baseDir = fileparts(mfilename('fullpath'));
addpath(genpath(fullfile(baseDir, 'functions')));
addpath(genpath(fullfile(baseDir, 'pipelines')));

inputDir = uigetdir('', 'Select the directory where the images are');
if isequal(inputDir, 0)
    error('No input directory selected.');
end

RunAdaptiveBandPassPipeline(inputDir, fullfile(inputDir, 'Pre_Processed'));
