function [roi_points, greenCountMat, redCountMat] = clicky(greenMov,redMov, Stim, frameTimes, sumTitle,varargin)

% Lets you select ROIS by left clicking to make a shape then right clicking
% to finish that shape.
% Then plots the fluorescence trace for that ROI
% You can select mutliple ROIs.
% A second right click prevents stops further ROIs from being drawn.


%% Plot reference image
refimg = mean(greenMov, 3);

figure
setCurrentFigurePosition(1) 
subplot(2,2,1)
imshow(refimg, [], 'InitialMagnification', 'fit')
hold on;
title('Mean image')

%% Get image details
nframes = size(greenMov, 3);
[ysize, xsize] = size(refimg(:,:,1));


%% Set colors
colorindex = 0;
ColorSet = distinguishable_colors(20,'b');
set(gca, 'ColorOrder', ColorSet);
order = get(gca,'ColorOrder');
purple = [97 69 168]./255;

%% Get ROIs
npts = 1;
nroi = 1;
greenCountMat = [];
redCountMat = [];
[x, y] = meshgrid(1:xsize, 1:ysize);
while(npts > 0)
    
    % Draw the ROI
    subplot(2,2,1)
    [xv, yv] = (getline(gca, 'closed'));
    if size(xv,1) < 3  % exit loop if only a line is drawn
        break
    end
    % Generate the mask
    inpoly = inpolygon(x,y,xv,yv);
    
    % Draw the bounding polygons and label them
    currcolor = order(nroi,:);
    plot(xv, yv, 'Linewidth', 1,'Color',currcolor);
    text(mean(xv),mean(yv),num2str(nroi),'Color',currcolor,'FontSize',12);
    
    % Calculate the mean trace within the polygon
    greenFCount = squeeze(sum(sum(greenMov.*repmat(inpoly, [1, 1, nframes]))))/sum(inpoly(:));
    redFCount = squeeze(sum(sum(redMov.*repmat(inpoly, [1, 1, nframes]))))/sum(inpoly(:));

    % Plot stimulus
    subplot(2,2,2)
    myplot(Stim.timeVec,Stim.stimulus,'Color',purple)
    ylabel('Stimulus (V)')
    set(gca,'xtick',[])
    set(gca,'XColor','white')
    title('Stimulus')
    
    % Plot the green trace
    subplot(2,2,4)
    hold on;
    myplot(frameTimes,greenFCount,'Color',currcolor,'Linewidth',2);
    colorindex = colorindex+1;
    ylabel('F count')
    xlabel('Time (s)')
    title('Green Channel')
    
    % Plot the red trace
    subplot(2,2,3)
    hold on;
    myplot(frameTimes,redFCount,'Color',currcolor,'Linewidth',2);
    colorindex = colorindex+1;
    ylabel('F count')
    xlabel('Time (s)')
    title('Red channel')
    
    % Figure formatting and add title 
    spaceplots    
    if exist('sumTitle','var')  
        suptitle(sumTitle)
    end    
    set(gca,'FontName','Calibri')
    
    % Create a matrix of traces
    greenCountMat = [greenCountMat; greenFCount'];
    redCountMat = [redCountMat; redFCount'];

    % Store the rois
    roi_points{nroi} = [xv, yv];
    nroi = nroi + 1;
end
greenCountMat = greenCountMat';
redCountMat = redCountMat';