function avgBack = ComputeAvgBackgroundFromVideo(vObj)
%COMPUTEAVGBACKGROUNDFROMVIDEO
%
% avgBack = ComputeAvgBackgroundFromVideo(vObj)
%
% OIST - 2020
% Julio Barros
%
% see also: VideoReader

avgBack = zeros(vObj.Height,vObj.Width);
N =vObj.NumFrames;
f = waitbar(0,'Computing Average Background');
for n=1:N
    frame = read(vObj,n);
    frame = rgb2gray(frame);
    avgBack = avgBack + double(frame);
    
    waitbar(n/N,f)
end
avgBack = avgBack ./ N;
avgBack = uint8(avgBack);
delete(f)