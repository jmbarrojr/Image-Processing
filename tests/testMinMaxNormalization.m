function tests = testMinMaxNormalization
tests = functiontests(localfunctions);
end

function setupOnce(testCase)
baseDir = fileparts(fileparts(mfilename('fullpath')));
addpath(genpath(baseDir));
end

function testNoNanForFlatImage(testCase)
A = uint16(ones(10,10) * 1000);
B = MinMaxNormalization(A, 3);
verifyClass(testCase, B, 'uint16');
verifyFalse(testCase, any(isnan(double(B(:)))));
verifyEqual(testCase, max(B(:)), uint16(0));
end

function testUint16BitDepth16(testCase)
A = uint16(repmat(uint16(linspace(0,65535,25)), 25, 1));
B = MinMaxNormalization(A, 3, 16);
verifyLessThanOrEqual(testCase, max(B(:)), uint16(65535));
end
