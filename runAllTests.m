function results = runAllTests()
%RUNALLTESTS Run all MATLAB unit tests in tests/.

baseDir = fileparts(mfilename('fullpath'));
addpath(genpath(baseDir));

suite = testsuite(fullfile(baseDir, 'tests'));
results = run(suite);
disp(results);
end
