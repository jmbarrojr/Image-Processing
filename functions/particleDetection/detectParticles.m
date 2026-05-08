function [centers, radii, stats, grayImage, binaryImage] = detectParticles(img, thr, avgBack, mask, filterImg)
%DETECTPARTICLES Detects particles in 2D images by thresholding and regionprops.
%
% [centers, radii, stats, grayImage, binaryImage] = detectParticles(img, thr)
% [centers, radii, stats, grayImage, binaryImage] = detectParticles(img, thr, avgBack, mask, filterImg)
%
% Inputs:
%   img       - 2D/3D image.
%   thr       - Threshold value.
%   avgBack   - Optional average background image.
%   mask      - Optional mask image.
%   filterImg - Optional logical scalar to apply morphological filtering.
%
% Output:
%   centers, radii, stats, grayImage, binaryImage
%
% OIST - 2026
% see also: applyMask, regionprops, getParticlesFromStat

narginchk(2,5);
if nargin < 3; avgBack = []; end
if nargin < 4; mask = []; end
if nargin < 5; filterImg = false; end

validateattributes(img, {'numeric','logical'}, {'nonempty'}, mfilename, 'img');
validateattributes(thr, {'numeric'}, {'scalar','real'}, mfilename, 'thr');
validateattributes(filterImg, {'logical','numeric'}, {'scalar'}, mfilename, 'filterImg');
filterImg = logical(filterImg);

if size(img,3) == 3
    grayImage = rgb2gray(img);
else
    grayImage = img;
end

if ~isempty(mask)
    grayImage = applyMask(grayImage, mask);
end

if ~isempty(avgBack)
    grayImage = grayImage - avgBack;
end

if filterImg
    grayImage = SlidingMaxFilter(grayImage);
end

binaryImage = grayImage > thr;

if filterImg
    binaryImage = SlidingMinFilter(binaryImage);
    binaryImage = medfilt2(binaryImage, [3 3]);
end

binaryImage = imfill(binaryImage, 8, 'holes');
CC = bwconncomp(binaryImage, 8);
labeledImage = labelmatrix(CC);
stats = regionprops(labeledImage, grayImage, 'Centroid', 'MajorAxisLength', 'MinorAxisLength', ...
    'MaxIntensity', 'MinIntensity', 'WeightedCentroid');
[centers, radii] = getParticlesFromStat(stats);
