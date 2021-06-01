function [centers,radii] = getParticlesFromStat(stats)
% Find all centers and radii from stats results from regionprops
%
% [centers,radii] = getParticlesFromStat(stats)
% 
% OIST - 2020
% Julio Barros
%
% see also: regionprops

N = length(stats);
centers = zeros(N,2);
radii = zeros(N,1);
for n=1:N
    centers(n,:) = stats(n).Centroid;
    diameters = mean([stats(n).MajorAxisLength stats(n).MinorAxisLength],2);
    radii(n) = diameters/2;
end