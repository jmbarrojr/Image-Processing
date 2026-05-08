function tests = testBackgroundSubtractNormalize
tests = functiontests(localfunctions);
end

function setupOnce(testCase)
baseDir = fileparts(fileparts(mfilename('fullpath')));
addpath(genpath(baseDir));
end

function testBackgroundSubtractNormalizeRanges(testCase)
A = uint16(ones(32,32) * 1000);
B = A;
B(10:12,10:12) = 3000;
[SubA, SubB] = BackgroundSubtractNormalize(A, B, 3, 'Method', 'median', 'BitDepth', 16);
verifyClass(testCase, SubA, 'uint16');
verifyClass(testCase, SubB, 'uint16');
verifyLessThanOrEqual(testCase, max(SubA(:)), uint16(65535));
verifyLessThanOrEqual(testCase, max(SubB(:)), uint16(65535));
end
