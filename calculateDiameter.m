function [maxDiameter, boundingBox] = calculateDiameter(binaryMask)
    stats = regionprops(binaryMask, 'BoundingBox', 'MajorAxisLength');
    maxDiameter = 0;
    boundingBox = [];
    
    for i = 1:numel(stats)
        diameters = sqrt([stats(i).BoundingBox(3)^2, stats(i).BoundingBox(4)^2]);
        maxDiameterCurrent = max(diameters);
        maxDiameter = max(maxDiameter, maxDiameterCurrent);
        
        if maxDiameterCurrent == maxDiameter
            boundingBox = stats(i).BoundingBox;
        end
    end
end
