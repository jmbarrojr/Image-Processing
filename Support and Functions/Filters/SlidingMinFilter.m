function B = SlidingMinFilter(A,kernel,type)
%SLIDINGMINFILTER This function filter the image with a sliding max
%
% B = SlidingMinFilter(A,kernel,type)
%
% OPTIONAL INPUTS: kernel (default = 3)
%                  type = 'disk'(default), 'square', but can be anything
%                  defined in strel
%
% Julio Barros
% see also: strel, imerode

% Check input variables
if ~exist('kernel','var')
    kernel = 3;
end
if ~exist('type','var')
    type = 'disk';
end

if strcmp(type,'disk')
    se = strel(type,floor(kernel/2));
else
    se = strel(type,kernel);
end
B = imerode(A,se);