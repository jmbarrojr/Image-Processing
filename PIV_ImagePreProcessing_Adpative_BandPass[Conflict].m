close all
clear all
clc

if ispc == 1
    slash = '\';
else
    slash = '/';
end

%pathDir = uigetdir('','Select the directory where the images are');
pathDir = 'K:\InsightPIVexp\ElizabethPIV\SlimeFullCoverage\RawData';
ext = 'Slime*.TIF';
files = dir([pathDir slash ext]);

%%
FolResults = [pathDir slash 'Pre_Processed'];
mkdir(FolResults);

N = length(files);

%disp('1: CLAHE ; 2: Intesity Capping; 3: all')
%type = input('?: ');

type = 3;

win = 16; % pixels

tic
for n=1:2
    ImgName = files(n).name;
    A = imread([pathDir slash ImgName]);
    if n == 1
        [J,I] = size(A);
        Lx = floor(I ./ win);
        Ly = floor(J ./ win);
    end
    
    Anorm = double(A) ./ double(max(A(:)));
    
    % Adaptive histogram Equalization
    if type == 1

        B = adapthisteq(Anorm,'NumTiles',[Ly Lx]);
        
        if isa(A,'uint8')
            B = uint8(B.*255);
        else
            B = uint16(B.*4095);
        end
        
        imwrite(B,[FolResults slash 'Ad_' ImgName],'tif','Compression','none');
        
    % Intesity Capping
    elseif type == 2

        if n == 1
            figure(1), colormap gray
            imagesc(A);
            roi = imrect;
            position = floor(wait(roi));
        end
        
        B = IntensityCapping(Anorm,position);
        
        if isa(A,'uint8')
            B = uint8(B.*255);
        else
            B = uint16(B.*4095);
        end
        imwrite(B,[FolResults slash 'Cap_' ImgName],'tif','Compression','none');
        
    % BOTH    
    elseif type == 3
        
        % Adaptive histogram Equalization
        B = adapthisteq(Anorm,'NumTiles',[Ly Lx]);
        
        if isa(A,'uint8')
            B = uint8(B.*255);
        else
            B = uint16(B.*4095);
        end
        imwrite(B,[FolResults slash 'Ad_' ImgName],'tif','Compression','none');
        
        % Intesity Capping
        if n == 1
            figure(1), colormap gray
            imagesc(A);
            roi = imrect;
            position = floor(wait(roi));
        end
        
        C = IntensityCapping(Anorm,position);
        if isa(A,'uint8')
            C = uint8(C.*255);
        else
            C = uint16(C.*4095);
        end
        imwrite(C,[FolResults slash 'Cap_' ImgName],'tif','Compression','none');
    end
    
end
toc

figure(2), colormap gray
subplot(2,2,[1 2]),imagesc(A),axis equal tight
subplot(2,2,3),imagesc(B), axis equal tight
subplot(2,2,4),imagesc(C), axis equal tight