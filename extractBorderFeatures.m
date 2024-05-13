function [perimeterLength, compactness, shapeFactor] = extractBorderFeatures(binaryMask, visualize)
    boundaries = bwboundaries(binaryMask, 'noholes');
    
    %Initialize variables to find longest boundary
    longestBoundaryIndex = 1;
    longestBoundaryLength = length(boundaries{1});

    %Loop through all boundaries to find longest one
    for k = 2:length(boundaries)
        currentBoundaryLength = length(boundaries{k});
        if currentBoundaryLength > longestBoundaryLength
            longestBoundaryIndex = k;
            longestBoundaryLength = currentBoundaryLength;
        end
    end

    %Retrieve the longest boundary and clculate its perimeter
    longestBoundary = boundaries{longestBoundaryIndex};
    perimeterLength = longestBoundaryLength;

    lesionArea = bwarea(binaryMask);
    
    %Calculate compactness using berimeter and area
    compactness = (perimeterLength^2) / lesionArea;
    shapeFactor = ( 4 * pi * lesionArea) / (perimeterLength^2);
    
    %If visualization is enabled
    if visualize
        figure;
        imshow(binaryMask);
        hold on;
        plot(longestBoundary(:,2), longestBoundary(:,1),'r', 'LineWidth',2);
        title('Lesion Boundry Visualization');
        hold off;
    end
end