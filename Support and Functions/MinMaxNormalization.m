function Anorm = MinMaxNormalization(A,Win)

% Local normalization based on local median intensity
Amin = SlidingMinFilter(double(A),Win);
Amax = SlidingMaxFilter(double(A),Win);
Anorm = (double(A) - Amin) ./ (Amax - Amin);

if isa(A,'uint8')
    Anorm = uint8(Anorm.*255);
    
elseif isa(A,'uint16') && max(A(:)) <= 4095
    Anorm = uint16(Anorm.*4095);
end