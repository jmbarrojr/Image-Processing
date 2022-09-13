function [Sub_rAfinal,Sub_rBfinal] = MinMaxNormalization(A,B,Win)
% LA = input Image LA
% LB = input Image LB
% Sub_rA = Output
% Sub_rB = Output

% Local normalization based on local median intensity
Amin = SlidingMinFilter(A,Win);
Amax = SlidingMaxFilter(A,Win);
NmedA = (A - Amin) ./ (Amax - Amin);

Bmin = SlidingMinFilter(B,Win);
Bmax = SlidingMaxFilter(B,Win);
NmedB = (B - Bmin) ./ (Bmax - Bmin);

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

% Final Images
Sub_rAfinal = uint8(Sub_rA * 256);
Sub_rBfinal = uint8(Sub_rB * 256);