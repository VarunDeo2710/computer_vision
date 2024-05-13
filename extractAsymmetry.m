function [verticalAsymmetryScore, horizontalAsymmetryScore] = extractAsymmetry(segmentedImage, visualize)
    grayImage = rgb2gray(segmentedImage);

    %Calculate vertical asymmetry score
    cols = size(grayImage, 2);
    middleCol = floor(cols / 2);

    %Split image into right/left halves
    lefthalf = grayImage(:, 1:middleCol);
    righthalf = grayImage(:, end:-1:(middleCol + 1));
    
    verticalAsymmetryScore = sum(abs(double(lefthalf(:)) - double(righthalf(:)))) / numel(lefthalf);

    %Calculate horizaontal asymmetry score
    rows = size(grayImage, 1);
    middleRow = floor(rows / 2);
    
    %Split image into top/bottom halves
    tophalf = grayImage(1:middleRow, :);
    bottomhalf = grayImage(end: -1:(middleRow +1), :);
    
    horizontalAsymmetryScore = sum(abs(double(tophalf(:)) - double(bottomhalf(:)))) / numel(tophalf);

    %if visualization is enabled, display images
    if visualize
        figure;
        subplot(2,2,1);
        imshow(lefthalf);
        title('Left Half');

        subplot(2,2,2);
        imshow(righthalf);
        title('Mirrored Right Half');

        subplot(2,2,3);
        imshow(tophalf);
        title('Top Half');
       
        subplot(2,2,4);
        imshow(bottomhalf);
        title('Mirrored Bottom Half');
        sgtitle(['Vertical Asymmetry Score: ', num2str(verticalAsymmetryScore), ...
            'Horizontal Asymmetry Score: ', num2str(horizontalAsymmetryScore)]);
    end
end