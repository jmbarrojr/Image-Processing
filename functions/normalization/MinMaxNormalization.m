function Anorm = MinMaxNormalization(A, win, bitDepth)
%MINMAXNORMALIZATION Local min-max normalization with safe denominator handling.
%
% Anorm = MinMaxNormalization(A, win)
% Anorm = MinMaxNormalization(A, win, bitDepth)
%
% Inputs:
%   A        - 2D numeric image.
%   win      - Sliding window size (positive integer).
%   bitDepth - Optional output scaling for uint16 inputs (12 or 16).
%              Default is 12 for backward compatibility.
%
% Output:
%   Anorm    - Normalized image in same integer class as input if input is
%              uint8/uint16, otherwise double in [0,1].
%
% OIST - 2026
% see also: SlidingMinFilter, SlidingMaxFilter

narginchk(2,3);
if nargin < 3
    bitDepth = [];
end

validateattributes(A, {'numeric','logical'}, {'2d','nonempty'}, mfilename, 'A');
validateattributes(win, {'numeric'}, {'scalar','integer','positive'}, mfilename, 'win');
if ~isempty(bitDepth)
    validateattributes(bitDepth, {'numeric'}, {'scalar','integer','member',[12 16]}, mfilename, 'bitDepth');
end

Amin = SlidingMinFilter(double(A), win);
Amax = SlidingMaxFilter(double(A), win);

den = max(Amax - Amin, eps);
Anorm = (double(A) - Amin) ./ den;
Anorm = max(min(Anorm, 1), 0);

if isa(A,'uint8')
    Anorm = uint8(Anorm .* 255);
elseif isa(A,'uint16')
    if isempty(bitDepth)
        bitDepth = 12;
    end
    if bitDepth == 16
        scale = 65535;
    else
        scale = 4095;
    end
    Anorm = uint16(Anorm .* scale);
end
