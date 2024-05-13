function [red, green, blue, colorDiversity] = extractColorVariability(segmentedImage, binaryMask)
    binaryMask = logical(binaryMask);

    redChl = segmentedImage(:,:,1);
    greenChl = segmentedImage(:,:,2);
    blueChl = segmentedImage(:,:,3);

    % Calculate standard deviation within the masked region
    red = std(double(redChl(binaryMask)));
    green = std(double(greenChl(binaryMask)));
    blue = std(double(blueChl(binaryMask)));
    
    % Quantize image to 16 colors and calculate color diversity within the mask
    quantizedImage = rgb2ind(segmentedImage, 16);
    colorDiversity = numel(unique(quantizedImage(binaryMask)));

    %figure;
    %subplot(1,2,1);
    %imshow(segmentedImage);
    %title('Segmented Image');

    overlayImage = repmat(uint8(binaryMask) * 255, [1,1,3]);
    combinedImage = imadd(segmentedImage, overlayImage);

    %subplot(1,2,2);
    %imshow(combinedImage);
    %title('Mask Overlay');
end