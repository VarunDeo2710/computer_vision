%Define paths for images, masks and labels
imPath = "D:\MSC\COP507_CV\images";
maPath = "D:\MSC\COP507_CV\masks";
laPath = "D:\MSC\COP507_CV\groundtruth.mat";
targetSize = [224 224];

%Load dataset with custom functions
[imds, mads, groundtruth] = loadData(imPath,maPath, laPath);
[preprocessedImages, preprocessedMasks, numericLabels] = preprocessData(imds, mads,groundtruth, targetSize);

%Initialize variables for feature extraction
numVisualizations = 1;
numBins = 256;
threshold = 0.01;
pixelTommRatio = 0.1;
numTotalFeatures = 12;
imfeatures = zeros(numel(imds.Files), numTotalFeatures);

for idx = 1:numel(imds.Files)

    originalImage = readimage(imds, idx);
    preprocessedMask = preprocessedMasks(:,:,idx);
    segmentedImage = applySegmentation(originalImage, preprocessedMask, targetSize, false);
    
    [perimeterLength, compactness, shapeFactor] = extractBorderFeatures(preprocessedMask, false);
    [red, green, blue, colorDiversity] = extractColorVariability(segmentedImage, preprocessedMask);   
    [verticalAsymmetryScore, horizontalAsymmetry] = extractAsymmetry(segmentedImage, false);  
    colorHistograms = extractColorHistograms(segmentedImage, preprocessedMask, numBins);
    colorDiversity = estimateColorDiversityFromHistograms(colorHistograms, threshold);
    [maxDiameterPixels, ~] = calculateDiameter(preprocessedMask);
    maxDiameterMm = maxDiameterPixels * pixelTommRatio;
    textureHeterogeneity = calculateHeterogeneity(calculateLBPFeatures(segmentedImage, preprocessedMask));    
    [morphMask, lesionArea, perimeter, eccentricity, solidity] = processMorphologicalFeatures(preprocessedMask);
    
    %Combine all extracted features in matrix
    imfeatures(idx, :) = [verticalAsymmetryScore, horizontalAsymmetry, perimeterLength, compactness, shapeFactor, maxDiameterMm, colorDiversity, textureHeterogeneity, lesionArea, perimeter, eccentricity, solidity];

    %Set 'numVisualization' to the desired image index to display its score

    %disp(['Vertical Asymmetry Score for Image ', num2str(idx), ' : ', num2str(verticalAsymmetryScore)]);
    %disp(['Horizontal Asymmetry Score for Image ', num2str(idx), ' : ', num2str(horizontalAsymmetry)]);
    %disp(['Border Feature for Image ', num2str(idx)]);
    %disp(['Perimeter Length: ', num2str(perimeterLength)]);
    %disp(['Compactness: ', num2str(compactness)]);
    %disp(['Shape Factor: ', num2str(shapeFactor)]);
    %disp(['Diameter for Image ', num2str(idx), ' : ',  num2str(maxDiameterMm), ' mm']);
    %disp(['Color Diversity for Image ', num2str(idx), ' : ',num2str(colorDiversity)]);
    %disp(['Texture Heterogeneity for Image ', num2str(idx), ' : ', num2str(textureHeterogeneity)]);
    %disp(['Area for Image ', num2str(idx), ' : ', num2str(lesionArea)]);
    %disp(['Perimeter for Image ', num2str(idx), ' : ', num2str(perimeter)]);
    %disp(['Eccentricity for Image ', num2str(idx), ' : ', num2str(eccentricity)]);
    %disp(['Solidity for Image ', num2str(idx), ' : ', num2str(solidity)]);
    
    %figure;
    %subplot(1, 3, 1);
    %bar(colorHistograms(:, 1), 'r');
    %title(['Red Channel Histogram for Image ', num2str(idx)]);

    %subplot(1, 3, 2);
    %bar(colorHistograms(:, 2), 'g');
    %title(['Green Channel Histogram for Image ', num2str(idx)]);

    %subplot(1, 3, 3);
    %bar(colorHistograms(:, 3), 'b');
    %title(['Blue Channel Histogram for Image ', num2str(idx)]);
    
    %subplot(1, 2, 1); imshow(segmentedImage); title(['Segmented Image ', num2str(idx)]);
    %subplot(1, 2, 2); imshow(morphMask); title(['Morphological Processing ', num2str(idx)]);

end

% perform classification using 10CV
rng(1); 
svmModel = fitcsvm(imfeatures, groundtruth, 'Standardize',true, 'KernelFunction','linear');
cvSVMModel = crossval(svmModel, 'KFold', 10);
pred = kfoldPredict(cvSVMModel);
[cm, order] = confusionmat(groundtruth, pred);
confusionchart (cm, order);

save('svmModel.mat', 'svmModel');

%Calculate and show performance metrics
[cm, order] = confusionmat(groundtruth, pred);
accuracy = sum(diag(cm)) / sum(cm(:));
precision = diag(cm) ./ sum(cm, 1)';
recall = diag(cm) ./ sum(cm, 2);
f1Scores = 2 * (precision .* recall) ./ (precision + recall);
macroF1Score = mean(f1Scores);

disp(['Accuracy: ', num2str(accuracy, '%.4f')]);
for i = 1:length(order)
    disp(['Precision for ', order{i}, ': ', num2str(precision(i), '%.4f')]);
    disp(['Recall (Sensitivity) for ', order{i}, ': ', num2str(recall(i), '%.4f')]);
    disp(['F1 Score for ', order{i}, ': ', num2str(f1Scores(i), '%.4f')]);
end
disp(['Macro-averaged F1 Score: ', num2str(macroF1Score, '%.4f')]);

