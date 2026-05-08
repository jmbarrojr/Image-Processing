function B = SlidingMedianFilter_GPU(A, win)
%SLIDINGMEDIANFILTER_GPU GPU median filter implementation.
%
% B = SlidingMedianFilter_GPU(A, win)
%
% Inputs:
%   A   - 2D numeric image.
%   win - Positive integer window size.
%
% Output:
%   B   - Median-filtered image (double).
%
% OIST - 2026
% see also: gpuArray, medfilt2, SlidingMedianFilter

narginchk(2,2);
validateattributes(A, {'numeric','logical'}, {'2d','nonempty'}, mfilename, 'A');
validateattributes(win, {'numeric'}, {'scalar','integer','positive'}, mfilename, 'win');

if gpuDeviceCount == 0
    B = double(SlidingMedianFilter(A, win));
    return;
end

Agpu = gpuArray(single(A));
Bgpu = medfilt2(Agpu, [win win]);
B = double(gather(Bgpu));
