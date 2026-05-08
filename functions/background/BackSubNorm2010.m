function [SubLA, SubLB, varargout] = BackSubNorm2010(LA, LB, Win, backNoise)
%BACKSUBNORM2010 Backward-compatible wrapper preserving 2010 behavior.
%
% [SubLA, SubLB] = BackSubNorm2010(LA, LB, Win, backNoise)
%
% OIST - 2026
% see also: BackgroundSubtractNormalize

if nargin < 4
    backNoise = [];
end

[SubLA, SubLB] = BackgroundSubtractNormalize(LA, LB, Win, ...
    'Method', 'minmax', 'BackgroundNoise', backNoise);

% Compatibility placeholders for historical optional outputs
varargout{1} = [];
varargout{2} = [];
