function [Sub_rAfinal,Sub_rBfinal] = BackgroundSubNormalization(A,B,Win)
% LA = input Image LA
% LB = input Image LB
% Sub_rA = Output
% Sub_rB = Output

if isa(A,'uint8') == 1
    type = 8;
elseif isa(A,'uint16') == 1
    type = 12;
end

A = double(A);
B = double(B);

% Local normalization based on local median intensity
Amin = SlidingMinFilter(A,Win);
Amed = SlidingMedianFilter(A,Win);
Amed = Amed + 1; % to avoid NaN and Inf
NmedA = (A - Amin) ./ (Amed - Amin);

Bmin = SlidingMinFilter(B,Win);
Bmed = SlidingMedianFilter(B,Win);
Bmed = Bmed + 1; % to avoid NaN and INf
NmedB = (B - Bmin) ./ (Bmed - Bmin);

% Subtraction Frame A from Frame B
Sub = NmedA - NmedB;

% Reconstruct Image for Frame A & B
index = Sub > 0;
Sub_rA = zeros(size(Sub));
Sub_rA(index) = Sub(index);

index = Sub < 0;
Sub_rB = zeros(size(Sub));
Sub_rB(index) = Sub(index);
Sub_rB = Sub_rB .* -1;

% Local normalization based on local max intensity
Sub_rAmin = SlidingMinFilter(Sub_rA,Win);
Sub_rAmax = SlidingMaxFilter(Sub_rA,Win);
Sub_rAfinal = (Sub_rA - Sub_rAmin) ./ (Sub_rAmax - Sub_rAmin);

Sub_rBmin = SlidingMinFilter(Sub_rB,Win);
Sub_rBmax = SlidingMaxFilter(Sub_rB,Win);
Sub_rBfinal = (Sub_rB - Sub_rBmin) ./ (Sub_rBmax - Sub_rBmin);

if type == 8 % 8-bit
    Sub_rAfinal = uint8(Sub_rAfinal * 255);
    Sub_rBfinal = uint8(Sub_rBfinal * 255);
    
elseif type == 12 % 12-bit
    Sub_rAfinal = uint16(Sub_rAfinal * 4095);
    Sub_rBfinal = uint16(Sub_rBfinal * 4095);
end