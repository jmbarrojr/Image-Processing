function [centers,radii,stats,grayImage] = detectParticles(img,thr,avgBack,mask)
%DETECTPARTICLES
% This function utilizes simple buit-in MATLAB functions to detect objetcs
% (usually particles) in a given image
%
% [centers,radii,stats,grayImage] = detectParticles(img,thr,avgBack,mask)
%
% see also: applyMask, regionprops

% Convert image to gray
grayImage = rgb2gray(img);

% Apply mask, if any
if exist('mask','var') && ~isempty(mask)
    grayImage = applyMask(grayImage,mask);
end

% Remove average backgorund
if exist('avgBack','var') && ~isempty(avgBack)
    grayImage = grayImage - avgBack;
end

% Binarize the image
binaryImage = grayImage > thr;

% Create connection regions
CC = bwconncomp(binaryImage,8);

% Label particles
labeledImage = labelmatrix(CC);

% Detect particles in frame
stats = regionprops(labeledImage,'Centroid','MajorAxisLength','MinorAxisLength');

% Get centers and radii from detected partcicles
[centers,radii] = getParticlesFromStat(stats);
end
%--------------------------------------------------------------------------
function [centers,radii] = getParticlesFromStat(stats)
N = length(stats);
centers = zeros(N,2);
radii = zeros(N,1);
for n=1:N
    centers(n,:) = stats(n).Centroid;
    diameters = mean([stats(n).MajorAxisLength stats(n).MinorAxisLength],2);
    radii(n) = diameters/2;
end
end