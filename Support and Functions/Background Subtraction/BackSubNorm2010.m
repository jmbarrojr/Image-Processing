function [SubLA,SubLB,varargout] = BackSubNorm2010(LA,LB,Win,backNoise)

if isa(LA,'uint8') == 1
    type = 8;
elseif isa(LA,'uint16') == 1
    type = 12;
end

LA = double(LA);
LB = double(LB);

% Experimental - Remove Background noise
LA(LA<backNoise) = 0;
LB(LB<backNoise) = 0;

% Experimental - CLAHE
%[J,I] = size(LA);
% LA = LA ./ max( LA(:));
% LB = LB ./ max( LB(:));
% Tilex = floor(I ./ 32);
% Tiley = floor(J ./ 32);
% LA = adapthisteq(LA,'NumTiles',[Tiley Tilex],'Range','original');
% LB = adapthisteq(LB,'NumTiles',[Tiley Tilex],'Range','original');

% Local normalization based on sliding min-max intensity
% LA Image
% Amin_g = min(LA(:));
% Amax_g = max(LA(:));
Amin = SlidingMinFilter(LA,Win);
Amax = SlidingMaxFilter(LA,Win);
N_LA = (LA - Amin) ./ (Amax - Amin);
% S_LA = (N_LA - Amin_g) ./ (Amax_g - Amin_g);

% LB Image
% Bmin_g = min(LB(:));
% Bmax_g = max(LB(:));
Bmin = SlidingMinFilter(LB,Win);
Bmax = SlidingMaxFilter(LB,Win);
N_LB = (LB - Bmin) ./ (Bmax - Bmin);
% S_LB = (N_LB - Bmin_g) ./ (Bmax_g - Bmin_g);

% Extract LA and LB images
SubLA = max(N_LA - N_LB,0);
SubLB = max(N_LB - N_LA,0);

if type == 8; % 8-bit
    SubLA = uint8(SubLA * 255);
    SubLB = uint8(SubLB * 255);
elseif type == 12 % 12-bit
    SubLA = uint16(SubLA * 4095);
    SubLB = uint16(SubLB * 4095);
end

varargout{1} = Amin;
varargout{2} = Amax;