function [preprocessedImages, preprocessedMasks, numericLabels] = preprocessData(imds, mads, groundtruth, targetSize)
    numImages = numel(imds.Files);
    preprocessedImages = zeros([targetSize 3 numImages]);
    preprocessedMasks = zeros([targetSize(1) targetSize(2) numImages]);
    numericLabels = grp2idx(groundtruth); %Convert labels from categorical to numeric

    %Iterate through each image wiht coresponding mask
    for i = 1:numImages
        image = imread(imds.Files{i});
        mask = imread(mads.Files{i});
        resizedImage = imresize(image, targetSize);
        resizedMask = imresize(mask, targetSize,"nearest");
        normalizeImage = double(resizedImage)/255;

        preprocessedImages(:,:,:,i) = normalizeImage;
        preprocessedMasks(:,:,i) = resizedMask > 0;
    end
end
