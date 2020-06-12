function [centers,radii,stats,grayImage,binaryImage] = detectParticles(img,thr,avgBack,mask,filterImg)
%DETECTPARTICLES
% This function utilizes simple buit-in MATLAB functions to detect objetcs
% (usually particles) in a given image
%
% [centers,radii,stats,grayImage] = detectParticles(img,thr,avgBack,mask)
%
% see also: applyMask, regionprops

% Convert image to gray
if size(img,3) == 3
    grayImage = rgb2gray(img);
else
    grayImage = img;
end

% Apply mask, if any
if exist('mask','var') && ~isempty(mask)
    grayImage = applyMask(grayImage,mask);
end

% Remove average backgorund
if exist('avgBack','var') && ~isempty(avgBack)
    grayImage = grayImage - avgBack;
end

if filterImg == true
    % Dialate the image
    grayImage = SlidingMaxFilter(grayImage);
end

% Binarize the image
binaryImage = grayImage > thr;

if filterImg == true
    % Erode to get back to the same size
    binaryImage = SlidingMinFilter(binaryImage);

    % Remove any 1 pixel "dust" or noise
    binaryImage = medfilt2(binaryImage,[3 3]);
end

% Fill holes, if any
binaryImage = imfill(binaryImage,8,'holes');

% Create connection regions
CC = bwconncomp(binaryImage,8);

% Label particles
labeledImage = labelmatrix(CC);

% Detect particles in frame
stats = regionprops(labeledImage,grayImage,'Centroid','MajorAxisLength','MinorAxisLength',...
    'MaxIntensity','MinIntensity','WeightedCentroid');

% Get centers and radii from detected partcicles
[centers,radii] = getParticlesFromStat(stats);
end