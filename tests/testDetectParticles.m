function tests = testDetectParticles
tests = functiontests(localfunctions);
end

function setupOnce(testCase)
baseDir = fileparts(fileparts(mfilename('fullpath')));
addpath(genpath(baseDir));
end

function testDetectSyntheticParticle(testCase)
img = uint8(zeros(64,64));
img(30,30) = 255;
[centers, radii, stats] = detectParticles(img, 200, [], [], false);
verifyGreaterThanOrEqual(testCase, numel(stats), 1);
verifyEqual(testCase, size(centers,2), 2);
verifyEqual(testCase, size(radii,2), 1);
end
