function mask = createMaskImg(img)
%CREATMASKIMG
%
% mask = createMaskImg(img)
% 
% OIST - 2020
% Julio Barros
%
% see also: drawpolygon

figure('Name','Mask Image'),imshow(img)
title('Draw the Region to Mask')
mask = drawpolygon('Color','r');