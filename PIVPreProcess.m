function PIVPreProcess()
%PIVPREPROCESS Unified entry point for PIV/PTV pre-processing pipelines.
%
% PIVPreProcess()
%
% OIST - 2026

baseDir = fileparts(mfilename('fullpath'));
addpath(genpath(fullfile(baseDir, 'functions')));
addpath(genpath(fullfile(baseDir, 'pipelines')));

pipelineIdx = menu('Select pre-processing pipeline', ...
    'Sliding Min-Max', ...
    'Adaptive Band-Pass', ...
    'Background Subtraction');

if pipelineIdx == 0
    disp('No pipeline selected.');
    return;
end

inputDir = uigetdir('', 'Select input image directory');
if isequal(inputDir, 0)
    disp('No input directory selected.');
    return;
end

outputDir = fullfile(inputDir, 'Pre_Processed');

switch pipelineIdx
    case 1
        answer = inputdlg({'Sliding min window','Normalization window','File extension (e.g., *.tif)'}, ...
            'Sliding Min-Max Options', [1 50], {'8','4','*.tif'});
        if isempty(answer); return; end
        opts = struct('windowSize', str2double(answer{1}), 'normWindow', str2double(answer{2}), 'fileExt', answer{3});
        RunSlidingMinMaxPipeline(inputDir, outputDir, opts);
    case 2
        answer = inputdlg({'Spot size','File extension (e.g., *.TIF)','Apply bandpass (0/1)'}, ...
            'Adaptive Band-Pass Options', [1 50], {'32','*.TIF','0'});
        if isempty(answer); return; end
        opts = struct('spotSize', str2double(answer{1}), 'fileExt', answer{2}, 'applyBandPass', logical(str2double(answer{3})));
        RunAdaptiveBandPassPipeline(inputDir, outputDir, opts);
    case 3
        answer = inputdlg({'Window size','File extension (e.g., *.TIF)','Method (median|minmax)'}, ...
            'Background Subtraction Options', [1 50], {'16','*.TIF','median'});
        if isempty(answer); return; end
        opts = struct('windowSize', str2double(answer{1}), 'fileExt', answer{2}, 'method', answer{3});
        RunBackgroundSubtraction(inputDir, outputDir, opts);
end

disp(['Done. Output folder: ' outputDir]);
