function lbpFeatures = calculateLBPFeatures(segmentedImage, binaryMask)
    grayImage = rgb2gray(segmentedImage);
    
    %Apply mask to focus on lesion
    maskedImage = grayImage;
    maskedImage(~binaryMask) = 0;

    %Extrcat LBP features from lesion area
    lbpFeatures = extractLBPFeatures(maskedImage, 'Upright', false);

    lbpFeatures = lbpFeatures(:)';
end