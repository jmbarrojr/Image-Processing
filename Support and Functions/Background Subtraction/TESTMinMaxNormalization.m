clear all
clc

if ispc == 1
    slash = '\';
else
    slash = '/';
end

pathDir = [pwd slash 'TestImages'];
files = dir([pathDir slash '*L*.TIF']);

n = 1;

Win = 16;

LA = imread([pathDir slash files(n).name]);
LA = double(LA);

LB = imread([pathDir slash files(n+1).name]);
LB = double(LB);


[J,I] = size(LA);
x = linspace(1,I,I);

%% Local normalization based on local max intensity
tic

Am = median(LA(:));
Amin = SlidingMinFilter(LA,Win);
Amax = SlidingMaxFilter(LA,Win);
h = fspecial('average',Win);
Amin = imfilter(Amin,h);
Amax = imfilter(Amax,h);
Anorm = (LA - (Amin+Am)) ./ (Amax - (Amin-Am));
Anorm(Anorm < 0) = 0;
Anorm(Anorm > 1) = 1;

Bm = median(LB(:));
Bmin = SlidingMinFilter(LB,Win);
Bmax = SlidingMaxFilter(LB,Win);
h = fspecial('average',Win);
Bmin = imfilter(Bmin,h);
Bmax = imfilter(Bmax,h);
Bnorm = (LB - (Bmin+Bm)) ./ (Bmax - (Bmin-Bm));
Bnorm(Bnorm < 0) = 0;
Bnorm(Bnorm > 1) = 1;

toc

Sub = Anorm-Bnorm;

index = Sub > 0;
Sub_rA = zeros(size(Sub));
Sub_rA(index) = Sub(index);

% Tile = floor(I ./ 32);
% Sub_rA = adapthisteq(Sub_rA,'NumTiles',[Tile Tile],'Range','original');

%% Sliding Min-Max Filter
tic
[Aanorm,Aamin,Aamax] = SlidingMinMax(LA,Win,Am);
toc
%contrast = Aamax - Aamin;

%% Ricardo's Back Subtraction
LA = imread([pathDir slash files(n).name]);
LB = imread([pathDir slash files(n+1).name]);
tic
[Sub_rLA,Sub_rLB] = BackgroundSubNormalization(LA,LB,Win);
toc

figure(101), colormap gray
subplot(2,1,1),imagesc(LA),axis equal
subplot(2,1,2),imagesc(Sub_rA,[0 1]),axis equal
subplot(4,1,3),imagesc(Sub_rLA),axis equal
subplot(4,1,4),imagesc(Aanorm,[0 1]),axis equal

%%
% ind = 128;
% figure(10),colormap gray
% subplot(2,2,1),imagesc(LA),axis([I/2-ind I/2+ind J/2-ind J/2+ind])
% subplot(2,2,2),imagesc(Aamin,[0 100]),axis([I/2-ind I/2+ind J/2-ind J/2+ind])
% subplot(2,2,3),imagesc(Aamax),axis([I/2-ind I/2+ind J/2-ind J/2+ind])
% subplot(2,2,4),imagesc(Aanorm,[0 1]),axis([I/2-ind I/2+ind J/2-ind J/2+ind])

% figure(11),colormap gray
% subplot(2,2,1),imagesc(contrast),axis([I/2-ind I/2+ind J/2-ind J/2+ind])
% subplot(2,2,2),imagesc(contrast > Am),axis([I/2-ind I/2+ind J/2-ind J/2+ind])
% subplot(2,2,3),imagesc(contrast - Am),axis([I/2-ind I/2+ind J/2-ind J/2+ind])
% subplot(2,2,4),imagesc(((contrast > Am) .* (contrast - Am) + Am)),axis([I/2-ind I/2+ind J/2-ind J/2+ind])

% figure(1)
% plot(x,A(J/2-5,:),'k',x,Amin(J/2-5,:),'b-.',x,Amax(J/2-5,:),'r-.');
% xlim([I/2-50 I/2+50])

% figure(2),colormap gray
% subplot(2,2,1),imagesc(LA),axis([I/2-ind I/2+ind J/2-ind J/2+ind])
% subplot(2,2,2),imagesc(Amin,[0 100]),axis([I/2-ind I/2+ind J/2-ind J/2+ind])
% subplot(2,2,3),imagesc(Amax),axis([I/2-ind I/2+ind J/2-ind J/2+ind])
% subplot(2,2,4),imagesc(Anorm,[0 1]),axis([I/2-ind I/2+ind J/2-ind J/2+ind])

% figure(3),colormap gray
% subplot(2,2,1),imagesc(A),axis([I/2-50 I/2+50 J/2-50 J/2+50])
% subplot(2,2,2),imagesc(A-Amin),axis([I/2-50 I/2+50 J/2-50 J/2+50])
% subplot(2,2,3),imagesc(Amax-Amin),axis([I/2-50 I/2+50 J/2-50 J/2+50])
% subplot(2,2,4),imagesc(Anorm,[0 1]),axis([I/2-50 I/2+50 J/2-50 J/2+50])
