function Ahigh = HighPass(A,size,clip_zero)

% High-pass filter
kernel = -ones(size,size);
kernel(ceil(size/2),ceil(size/2)) = size*size-1;

Ahigh = imfilter(double(A),kernel);

switch clip_zero
    case 1
        Ahigh(Ahigh<0) = 0;
end

maxA = max(Ahigh(:));
minA = min(Ahigh(:));
Ahigh = (Ahigh - minA )./(maxA - minA );

if isa(A,'uint8')
    Ahigh = uint8(Ahigh.*255);
    
elseif isa(A,'uint16') && max(A(:)) <= 4095
    Ahigh = uint16(Ahigh.*4095);
    
end