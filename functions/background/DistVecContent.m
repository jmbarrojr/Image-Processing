function [DistVec] = DistVecContent(cores, vecContent)
%DISTVECCONTENT Splits vector content across workers.
%
% DistVec = DistVecContent(cores, vecContent)
%
% Note: For distributed execution, open a parallel pool with parpool first.
%
% Author: Julio Barros - UIUC (historical source)

validateattributes(cores, {'numeric'}, {'scalar','integer','positive'}, mfilename, 'cores');

a = length(vecContent) / cores;

spmd
    DistVec = [];
end

j = 1;
for i = 1:cores
    if i ~= cores
        DistVec{i} = vecContent(j : (i * floor(a)));
        j = j + floor(a);
    else
        DistVec{i} = vecContent(j : end);
    end
end
