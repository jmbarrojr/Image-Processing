function Ahigh = HighPass(A, kernelSize, clipZero)
%HIGHPASS High-pass filter with normalized output.
%
% Ahigh = HighPass(A, kernelSize, clipZero)
%
% Inputs:
%   A          - 2D numeric image.
%   kernelSize - Odd positive integer filter size.
%   clipZero   - Logical scalar. When true, clips negatives to zero.
%
% Output:
%   Ahigh      - Filtered image scaled to [0,1] then cast to uint8/uint16
%                when input is integer.
%
% OIST - 2026
% see also: imfilter

narginchk(3,3);
validateattributes(A, {'numeric','logical'}, {'2d','nonempty'}, mfilename, 'A');
validateattributes(kernelSize, {'numeric'}, {'scalar','integer','positive'}, mfilename, 'kernelSize');
validateattributes(clipZero, {'logical','numeric'}, {'scalar'}, mfilename, 'clipZero');

kernel = -ones(kernelSize, kernelSize);
kernel(ceil(kernelSize/2), ceil(kernelSize/2)) = kernelSize * kernelSize - 1;

Ahigh = imfilter(double(A), kernel);

if logical(clipZero)
    Ahigh(Ahigh < 0) = 0;
end

maxA = max(Ahigh(:));
minA = min(Ahigh(:));
Ahigh = (Ahigh - minA) ./ max(maxA - minA, eps);

if isa(A,'uint8')
    Ahigh = uint8(Ahigh .* 255);
elseif isa(A,'uint16')
    if max(A(:)) <= 4095
        Ahigh = uint16(Ahigh .* 4095);
    else
        Ahigh = uint16(Ahigh .* 65535);
    end
end
