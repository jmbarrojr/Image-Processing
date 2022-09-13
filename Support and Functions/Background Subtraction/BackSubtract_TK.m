%% Background subtraction
% Function to subtract background using local median & max intensity
%
% Author: Taehoon Kim & Julio Barros - UIUC 2014
% version: 1.0

clear all
close all
clc

%%%%%%%%%%%%%%%
% USER INPUTS %
%%%%%%%%%%%%%%%

% Define window size
type = input('Type your window size(pixel based) : ');
Win = type;

if ispc == 1
    slash = '\';
else
    slash = '/';
end

path = uigetdir('','Select the directory where the images are');
%ext = '*.TIF';

%%
filesLA = dir([path slash '*.LA.TIF']);
filesLB = dir([path slash '*.LB.TIF']);
filesRA = dir([path slash '*.RA.TIF']);
filesRB = dir([path slash '*.RB.TIF']);

% %%%%%%%%%%
% % DEBUG
% %%%%%%%%%%
% filesLA = filesLA(1:10,:);
% filesLB = filesLB(1:10,:);
% filesRA = filesRA(1:10,:);
% filesRB = filesRB(1:10,:);

% make folder for normalized files
FolResults = [path slash 'Pre_Processed'];
mkdir(FolResults);


% Close if there is any open pool
if matlabpool('size') > 0;
    matlabpool close force local
end

% Start the Parallel pools
matlabpool open
cores = matlabpool('size'); % Number of cores availabe in the computer

tstart_p = tic; % Start computing Time

% Split the list of the files into the number of cores
[CompVecListLA] = DistVecContent(cores,filesLA);
[CompVecListLB] = DistVecContent(cores,filesLB);
[CompVecListRA] = DistVecContent(cores,filesRA);
[CompVecListRB] = DistVecContent(cores,filesRB);

disp('Calculating background subtraction')

spmd
    Np = length(CompVecListLA);
    
    for n = 1 : Np
        ImgLA = CompVecListLA(n).name;
        ImgLB = CompVecListLB(n).name;
        ImgRA = CompVecListRA(n).name;
        ImgRB = CompVecListRB(n).name;
        
        LA = double(imread([path slash ImgLA]));
        LB = double(imread([path slash ImgLB]));
        RA = double(imread([path slash ImgRA]));
        RB = double(imread([path slash ImgRB]));
        
        [Sub_rLA,Sub_rLB] = BackgroundSubNormalization(LA,LB,Win);
        [Sub_rRA,Sub_rRB] = BackgroundSubNormalization(RA,RB,Win);
        
        
        % save back to image files
        imwrite(Sub_rLA,[FolResults slash 'Norm_' ImgLA],'TIFF')
        imwrite(Sub_rLB,[FolResults slash 'Norm_' ImgLB],'TIFF')
        
        imwrite(Sub_rRA,[FolResults slash 'Norm_' ImgRA],'TIFF')
        imwrite(Sub_rRB,[FolResults slash 'Norm_' ImgRB],'TIFF')
        
    end
end

tstop_p = toc(tstart_p);

disp('DONE')
disp([num2str(tstop_p/60) ' minutes taken'])

% Close Matlab Pool
matlabpool close