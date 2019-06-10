clear all
close all
clc


Win = 64;

if ispc == 1
    slash = '\';
else
    slash = '/';
end


path = 'C:\Users\tkim91\Desktop\test\Hemi_0-67k';
FolResults = [path slash 'Pre_Processed'];
mkdir(FolResults);

filesLA = dir([path slash '*.LA.TIF']);
filesLB = dir([path slash '*.LB.TIF']);
% filesRA = dir([path slash '*.RA.TIF']);
% filesRB = dir([path slash '*.RB.TIF']);

ImgLA = filesLA(1).name;
ImgLB = filesLB(1).name;
% ImgRA = filesRA(1).name;
% ImgRB = filesRB(1).name;

LA = double(imread([path slash ImgLA]));
LB = double(imread([path slash ImgLB]));
% RA = double(imread([path slash ImgRA]));
% RB = double(imread([path slash ImgRB]));

%LA = LA(1:512,1:512);
%LB = LB(1:512,1:512);

[NormLA,NormLB] = BackgroundSubNormalization(LA,LB,Win);

figure(1)
colormap gray
subplot(2,2,1),imagesc(LA)
subplot(2,2,2),imagesc(NormLA)
subplot(2,2,3),imagesc(LB)
subplot(2,2,4),imagesc(NormLB)

imwrite(NormLA,[FolResults slash 'Norm_' ImgLA],'TIFF')
imwrite(NormLB,[FolResults slash 'Norm_' ImgLB],'TIFF')