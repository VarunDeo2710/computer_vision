function [processedMask, lesionArea, perimeter, eccentricity, solidity] = processMorphologicalFeatures( ...
    preprocessedMask)
    %Create a structural elemnent for morphological operations
    se = strel('disk', 5);
    
    morphClosed = imclose(preprocessedMask, se);
    morphOpened = imopen(morphClosed, se);
    
    processedMask = morphOpened;
    morphFeatures = regionprops(processedMask,'Area', 'Perimeter', 'Eccentricity', 'Solidity');
    
    lesionArea = morphFeatures.Area;
    perimeter = morphFeatures.Perimeter;
    eccentricity = morphFeatures.Eccentricity;
    solidity = morphFeatures.Solidity;
end