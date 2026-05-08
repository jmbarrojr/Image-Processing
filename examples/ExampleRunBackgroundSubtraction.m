% ExampleRunBackgroundSubtraction
baseDir = fileparts(fileparts(mfilename('fullpath')));
addpath(genpath(fullfile(baseDir, 'functions')));
addpath(genpath(fullfile(baseDir, 'pipelines')));

inputDir = uigetdir('', 'Select input image directory');
if isequal(inputDir, 0); return; end
opts = struct('windowSize', 16, 'fileExt', '*.TIF', 'method', 'median');
RunBackgroundSubtraction(inputDir, fullfile(inputDir, 'Pre_Processed'), opts);
