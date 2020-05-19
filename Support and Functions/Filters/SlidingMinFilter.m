function B = SlidingMinFilter(A,Win)
%
% VERSION 2
%Apad = padarray(A,[Win/2 Win/2]);

% MATLAB WAY
se = strel('disk',floor(Win/2));
B = imerode(A,se);
% B = imerode(A,true(Win));

%C = zeros(size(A));
%C = B(Win/2:end-(Win/2+1),Win/2:end-(Win/2+1));

% % JULIO'S SHITY WAY
% BJ = zeros(size(A));
% 
% x = [1:Win]';
% y = [1:Win]';
% 
% for i= 1:size(Apad,1)-Win
%     for j=1:size(Apad,2)-Win
%       
%        %VECTORIZED METHOD 
%        window = Apad(i+x-1,j+y-1);
% 
%        %FIND THE MINIMUM VALUE IN THE SELECTED WINDOW
%         BJ(i,j) = min(window(:));
% 
%     end
% end

% CJ = BJ;%(Win/2+1:end-Win/2+1,Win/2+1:end-Win/2+1);
