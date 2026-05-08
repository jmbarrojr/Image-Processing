function B = SlidingMedianFilter(A, win)
%SLIDINGMEDIANFILTER Applies median filtering with square window.
%
% B = SlidingMedianFilter(A, win)
%
% Inputs:
%   A   - 2D numeric image.
%   win - Positive integer window size.
%
% Output:
%   B   - Median-filtered image.
%
% OIST - 2026
% see also: medfilt2

narginchk(2,2);
validateattributes(A, {'numeric','logical'}, {'2d','nonempty'}, mfilename, 'A');
validateattributes(win, {'numeric'}, {'scalar','integer','positive'}, mfilename, 'win');

B = medfilt2(A, [win win]);
