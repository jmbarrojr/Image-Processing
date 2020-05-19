function img = applyMask(img,mask)
%APPLYMASK
%
% img = applyMask(img,mask)
%
% OIST - 2020
% Julio Barros
%
% see also: creatMask

mask = createMask(mask);
mask = mask == 0;
img = img .* uint8(mask);