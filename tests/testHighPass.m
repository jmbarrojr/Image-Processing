function tests = testHighPass
tests = functiontests(localfunctions);
end

function setupOnce(testCase)
baseDir = fileparts(fileparts(mfilename('fullpath')));
addpath(genpath(baseDir));
end

function testHighPassOutputRangeAndType(testCase)
A = uint8(randi([0 255], 32, 32));
B = HighPass(A, 3, true);
verifyEqual(testCase, size(B), size(A));
verifyClass(testCase, B, 'uint8');
verifyGreaterThanOrEqual(testCase, min(B(:)), uint8(0));
verifyLessThanOrEqual(testCase, max(B(:)), uint8(255));
end
