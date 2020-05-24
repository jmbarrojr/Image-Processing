function [Apar,particle_list] = dynamicThreshold(A,Ithr,Cthr,varargin)
%DYNAMICTHRESHOLD
% This function segments a PIV/PTV image to determine all the particles.
% This is based on Mikheev & Zubtsov (2008) paper.
%
% INPUT: A    - Image to be segmented
%        Ithr - background noise threshold value
%        Cthr - Contrast ratio for the detect particles (0.2 is good for 
%               cleannumber for 8-bit images). Increase the value if background
%               noise is being captured or to make parciles smaler.
%              
%
% OPTIONAL INPUT: Win - Size of the sliding-max filter (default is 3)
%
% Author: Julio Barros
% OIST 2019

if nargin == 3
    win = 3;
elseif nargin == 4
    win = varargin{1};
else
    error('Two many inputs.')
    
end

% Get image size
[Sx,Sy] = size(A);

% Apply a sliding-max filter to detect the brightest spots of all particles
% behond Ithr value
Amax = SlidingMaxFilter(A,win);
Amax(Amax<Ithr) = 0;

Aseg = double(A) ./ double(Amax);
Aseg = Aseg == 1;
[row_ind,col_ind,~] = find(Aseg == 1);
Npar = length(row_ind);

for n = 1:Npar
    particle_list(n).center = [row_ind(n),col_ind(n)];
end

% Aopen = Aseg; % Initialization
% Apar = zeros(size(A));
Apar = Aseg;

%c = [row_ind,col_ind]; % Counter
s = 1; % border
%while ~isempty(c)

% Expand the particles borders 3 times
for d=1:3
    % Expand the border of located particles by 1px
    %se = strel('square',3);
    %Aopen = imdilate(Aseg,se);
    
    for i=1:Npar
        % Horizontal borders (DOUBLE CHECK)
        if row_ind(i) == 1
            sx = row_ind(i) : row_ind(i)+s;
            px = 1; %%%% ADDED
        elseif row_ind(i) == Sx
            sx = row_ind(i)-s : row_ind(i);
            px = length(sx); %%%% ADDED
        elseif row_ind(i) > s && row_ind(i) < Sx-s
            sx = row_ind(i)-s : row_ind(i)+s;
            px = (length(sx)+1)/2; %%%% ADDED
        end
        % Vertical borders (DOUBLE CHECK)
        if col_ind(i) == 1
            sy = col_ind(i) : col_ind(i)+s;
            py = 1; %%%% ADDED
        elseif col_ind(i) == Sy
            sy = col_ind(i)-s : col_ind(i);
            py = length(sy); %%%% ADDED
        elseif col_ind(i) > s && col_ind(i) < Sy-s
            sy = col_ind(i)-s : col_ind(i)+s;
            py = (length(sy)+1)/2; %%%% ADDED
        end  

        % Calculate the contrast-ratio between the adjacent Ii,j and Imax
        Atemp = double(A(sx,sy)) ./ double(A(row_ind(i),col_ind(i)));
        % If contrast-ratio value is higher, then mark the surrounding
        % pixels if 1 and add to the particle 'list'
        Atemp = Atemp > Cthr;
        Apar(sx,sy) = Atemp;
        Img = A(sx,sy) .* uint8(Atemp);
        
        % Remove pixels that are brighter than the center (possible other
        % particles
        Img(Img >= A(row_ind(i),col_ind(i))) = 0;
        % Put the particle center back in
        Img(px,py) = A(row_ind(i),col_ind(i));%%%% ADDED
        
        particle_list(i).Img = Img;
        
        % ATTEMPT TO REMOVE THE TEMP LIST OF PARTICLE LOCATION TO AVOID
        % FIRST FOR LOOP (NEEDS WORK)
        % if sum(Atemp) == sum(size(Atemp))
        %     c(i,:) = [];
        % end
        
%         Atemp = A(sx,sy);
%         [rx,ry,~] = find(Atemp==A(row_ind(i),col_ind(i)) );
%         Atemp(rx,ry) = 0;
%         
%         Ctemp = mean(Atemp(:)) ./ double(A(row_ind(i),col_ind(i)));
%         
%         if Ctemp <= 0.09
%             Apar(sx,sy) = A(sx,sy);
%             figure(2), colormap gray,imagesc(Apar),axis equal tight
%             c(i,:) = [];
%             if isempty(c)
%                 break
%             end
%             disp('Found shit')
%         end
    end
    
    % Increase border by 1 pixel
    s = s + 1;
end

% DEBUG FIGURE
figure(1), colormap gray
subplot(3,1,1),imagesc(A),hold on, plot(col_ind,row_ind,'ro'), hold off,...
axis equal tight, xlim([0 100]),ylim([0 50])

subplot(3,1,2),imagesc(Aseg),axis equal tight, xlim([0 100]),ylim([0 50])
subplot(3,1,3),imagesc(Apar),axis equal tight, xlim([0 100]),ylim([0 50])
