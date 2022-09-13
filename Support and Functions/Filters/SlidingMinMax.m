function [corrected,varargout] = SlidingMinMax(original,FiltSize,varargin)

if nargin == 2
    Level = median(original(:));
elseif nargin == 3
    Level = varargin{1};
end

domain = ones(FiltSize,FiltSize);
N = size(domain,1)*size(domain,2);
low = filter2(domain,ordfilt2(original,1,domain))/N;
upp = filter2(domain,ordfilt2(original,N,domain))/N;
contrast = upp-low;

% cont = immultiply(contrast > Level,contrast - Level) + Level;
% corrected = 64*imdivide(original-low,cont);

cont = ((contrast > Level) .* (contrast - Level) + Level);
corrected = (original-low) ./ cont;

varargout{1} = low;
varargout{2} = upp;
