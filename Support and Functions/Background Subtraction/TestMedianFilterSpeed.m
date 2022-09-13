close all
clear all
clc

if ispc == 1
    slash = '\';
else
    slash = '/';
end

pathDir = [pwd slash 'TestImages'];
file = 'SlimeFullCoverage062915ZO000001.T000.D000.P000.H000.LA.TIF';

A = imread([pathDir slash file]);
A = double(A);

%A = A(1:2048,1:2048);

Win = 16;

tic
B = SlidingMedianFilter(A,Win);
toc

tic
    Aa = distributed(A);
spmd
    Aaa = getLocalPart(Aa);
    Bb = medfilt2(Aaa,[Win Win]);
end
Bb = [Bb{1} Bb{2}];
toc

figure(2)
subplot(1,2,1),imagesc(B),axis equal tight
subplot(1,2,2),imagesc(Bb),axis equal tight

