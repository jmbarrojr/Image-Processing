function tests = testSlidingMinFilter
tests = functiontests(localfunctions);
end

function setupOnce(testCase)
baseDir = fileparts(fileparts(mfilename('fullpath')));
addpath(genpath(baseDir));
end

function testShapeAndValues(testCase)
A = uint8([5 4 3; 2 9 8; 1 7 6]);
B = SlidingMinFilter(A, 3);
expected = imerode(A, strel('disk', floor(3/2)));
verifyEqual(testCase, size(B), size(A));
verifyEqual(testCase, B, expected);
end
