close all
clear
clc

if ispc == 1
    slash = '\';
else
    slash = '/';
end

%path = uigetdir('','Select the directory where the images are');
path = 'M:\Experiments10\Barnacle Array\X-Z - y_h=1 Plane\RawData';

ext = '*.TIF';
files = dir([path slash ext]);

%%
FolResults = [path slash 'Pre_Processed'];
mkdir(FolResults);

N = length(files);

spot = 32;

tic
for n=1:1
    ImgName = files(n).name;
    A = imread([path slash ImgName]);
    Aa = double(A) ./ double(max(A(:)));
    [J,I] = size(A);
    winx = floor(I ./ spot);
    winy = floor(J ./ spot);
    
    % Adaptive histogram Equalization
    B = adapthisteq(Aa,'NumTiles',[winy winx],'Range','original');
    
    % Band-pass Filter
    %B = bpass(B,2,3);
    
    if isa(A,'uint8')
        Imax = 255;
        B = uint8(B .* Imax);
    else
        Imax = 2^12 - 1;
        B = uint16(B .* Imax);
    end
    
    %imwrite(B,[FolResults slash 'Ad_' ImgName],'tif','Compression','none');
    
end

figure(1)
colormap gray
subplot(1,2,1),imagesc(A,[0 Imax]),axis equal tight
subplot(1,2,2),imagesc(B,[0 Imax]),axis equal tight
toc