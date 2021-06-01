function img = applyMask(img,mask)
%APPLYMASK
%
% img = applyMask(img,mask)
%
% OIST - 2020
% Julio Barros
%
% see also: immultiply

img = immultiply(img,mask);