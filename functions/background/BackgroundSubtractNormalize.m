function [SubA, SubB] = BackgroundSubtractNormalize(A, B, win, varargin)
%BACKGROUNDSUBTRACTNORMALIZE Background subtraction with optional method variants.
%
% [SubA, SubB] = BackgroundSubtractNormalize(A, B, win)
% [SubA, SubB] = BackgroundSubtractNormalize(A, B, win, 'Method', method, ...)
%
% Name-value options:
%   Method          - 'median' (default) or 'minmax'
%   BackgroundNoise - Scalar noise floor to zero-out before processing
%   BitDepth        - [] (auto), 12, or 16 for uint16 outputs
%
% OIST - 2026
% see also: SlidingMinFilter, SlidingMaxFilter, SlidingMedianFilter

narginchk(3,9);

p = inputParser;
addParameter(p, 'Method', 'median', @(x) ischar(x) || isstring(x));
addParameter(p, 'BackgroundNoise', [], @(x) isempty(x) || (isnumeric(x) && isscalar(x)));
addParameter(p, 'BitDepth', [], @(x) isempty(x) || (isnumeric(x) && isscalar(x) && any(x == [12 16])));
parse(p, varargin{:});

method = lower(string(p.Results.Method));
backNoise = p.Results.BackgroundNoise;
bitDepth = p.Results.BitDepth;

validateattributes(A, {'numeric','logical'}, {'2d','nonempty'}, mfilename, 'A');
validateattributes(B, {'numeric','logical'}, {'2d','nonempty','size',size(A)}, mfilename, 'B');
validateattributes(win, {'numeric'}, {'scalar','integer','positive'}, mfilename, 'win');

inClass = class(A);
A = double(A);
B = double(B);

if ~isempty(backNoise)
    A(A < backNoise) = 0;
    B(B < backNoise) = 0;
end

switch method
    case "median"
        Amin = SlidingMinFilter(A, win);
        Amed = SlidingMedianFilter(A, win) + 1;
        N_A = (A - Amin) ./ max(Amed - Amin, eps);

        Bmin = SlidingMinFilter(B, win);
        Bmed = SlidingMedianFilter(B, win) + 1;
        N_B = (B - Bmin) ./ max(Bmed - Bmin, eps);

        Sub = N_A - N_B;
        SubA = max(Sub, 0);
        SubB = max(-Sub, 0);

        SubAmin = SlidingMinFilter(SubA, win);
        SubAmax = SlidingMaxFilter(SubA, win);
        SubA = (SubA - SubAmin) ./ max(SubAmax - SubAmin, eps);

        SubBmin = SlidingMinFilter(SubB, win);
        SubBmax = SlidingMaxFilter(SubB, win);
        SubB = (SubB - SubBmin) ./ max(SubBmax - SubBmin, eps);

    case "minmax"
        Amin = SlidingMinFilter(A, win);
        Amax = SlidingMaxFilter(A, win);
        N_A = (A - Amin) ./ max(Amax - Amin, eps);

        Bmin = SlidingMinFilter(B, win);
        Bmax = SlidingMaxFilter(B, win);
        N_B = (B - Bmin) ./ max(Bmax - Bmin, eps);

        SubA = max(N_A - N_B, 0);
        SubB = max(N_B - N_A, 0);

    otherwise
        error('BackgroundSubtractNormalize:InvalidMethod','Unknown method: %s', method);
end

SubA = max(min(SubA, 1), 0);
SubB = max(min(SubB, 1), 0);

if isa(cast(0, inClass), 'uint8')
    SubA = uint8(SubA * 255);
    SubB = uint8(SubB * 255);
elseif isa(cast(0, inClass), 'uint16')
    if isempty(bitDepth)
        bitDepth = 12;
    end
    if bitDepth == 16
        scale = 65535;
    else
        scale = 4095;
    end
    SubA = uint16(SubA * scale);
    SubB = uint16(SubB * scale);
end
