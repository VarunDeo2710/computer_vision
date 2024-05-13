function segmentedImage = applySegmentation(originalImage, prerocessedMask, targetSize, visualize)
    resizedImage = imresize(originalImage, targetSize);

    %Confirm Mask is binary for masking operations
    logicalMask = logical(prerocessedMask);

    segmentedImage = zeros(size(resizedImage), 'like', resizedImage);

    %Apply mask to each color channel
    for k = 1:3
        segmentedImage(:,:,k) = resizedImage(:,:,k) .*uint8(logicalMask);
    end
    
    %if visualization is enable, display segmented image
    if visualize
        figure;
        imshow(segmentedImage);
        title('Segmented Image');
    end
end