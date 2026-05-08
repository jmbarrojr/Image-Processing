% ExampleRunSlidingMinMax
baseDir = fileparts(fileparts(mfilename('fullpath')));
addpath(genpath(fullfile(baseDir, 'functions')));
addpath(genpath(fullfile(baseDir, 'pipelines')));

inputDir = uigetdir('', 'Select input image directory');
if isequal(inputDir, 0); return; end
opts = struct('windowSize', 8, 'normWindow', 4, 'fileExt', '*.tif');
RunSlidingMinMaxPipeline(inputDir, fullfile(inputDir, 'Pre_Processed'), opts);
