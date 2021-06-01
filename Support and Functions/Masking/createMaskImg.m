function mask = createMaskImg(img)
%CREATMASKIMG
%
% mask = createMaskImg(img)
% 
% OIST - 2020
% Julio Barros
%
% see also: drawpolygon

% Draw Image
figure('Name','Mask Image'),imshow(img)
title('Draw the Region to Mask')
roiObj = drawpolygon('Color','r');

% Make mask from ROI object
mask = createMask(roiObj);

% Invert pixels;
mask = mask == 0;

% Convert to uint8
mask = uint8(mask);