function B = IntensityCapping(A, ROI)
%INTENSITYCAPPING Caps intensities above local median + 2*std inside ROI.
%
% B = IntensityCapping(A, ROI)
%
% Inputs:
%   A   - 2D numeric image (preferably double normalized to [0,1]).
%   ROI - [x1 y1 x2 y2] rectangle bounds.
%
% Output:
%   B   - Intensity-capped image.
%
% OIST - 2026
% see also: median, std

narginchk(2,2);
validateattributes(A, {'numeric','logical'}, {'2d','nonempty'}, mfilename, 'A');
validateattributes(ROI, {'numeric'}, {'vector','numel',4,'integer','positive'}, mfilename, 'ROI');

x1 = ROI(1); y1 = ROI(2); x2 = ROI(3); y2 = ROI(4);
validateattributes(x2, {'numeric'}, {'>=',x1}, mfilename, 'ROI(3)');
validateattributes(y2, {'numeric'}, {'>=',y1}, mfilename, 'ROI(4)');

B = A;
region = B(y1:y2, x1:x2);
Imed = median(region(:));
Istd = std(region(:));
c = 2;
mask = B > (Imed + c * Istd);
B(mask) = Imed + c * Istd;
