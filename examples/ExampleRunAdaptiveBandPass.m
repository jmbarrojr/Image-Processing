% ExampleRunAdaptiveBandPass
baseDir = fileparts(fileparts(mfilename('fullpath')));
addpath(genpath(fullfile(baseDir, 'functions')));
addpath(genpath(fullfile(baseDir, 'pipelines')));

inputDir = uigetdir('', 'Select input image directory');
if isequal(inputDir, 0); return; end
opts = struct('spotSize', 32, 'fileExt', '*.TIF', 'applyBandPass', false);
RunAdaptiveBandPassPipeline(inputDir, fullfile(inputDir, 'Pre_Processed'), opts);
