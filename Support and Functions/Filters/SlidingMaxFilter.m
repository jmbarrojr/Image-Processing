function B = SlidingMaxFilter(A,Win)

%Apad = padarray(A,[Win/2 Win/2]);

% Matlab function
se = strel('disk',floor(Win/2));
B = imdilate(A,se);
%B = imdilate(A,true(Win));

%C = zeros(size(A));
%C = B(Win/2:end-(Win/2+1),Win/2:end-(Win/2+1));

% % Julio's Way
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
%         BJ(i,j) = max(window(:));
% 
%     end
% end
% 
% CJ = BJ;%(Win/2+1:end-Win/2+1,Win/2+1:end-Win/2+1);