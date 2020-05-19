function B = SlidingMedianFilter(A,Win)

B = medfilt2(A,[Win Win]);

% B = zeros(size(A));
% 
% Apad = padarray(A,[Win/2 Win/2]);
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
%         B(i,j) = median(window(:));
% 
%     end
% end