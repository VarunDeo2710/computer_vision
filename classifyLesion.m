function classifyLesion(imagePath, maskPath)

    model = load('svmModel.mat');
    svmModel = model.svmModel;

    targetSize = [224, 224];
    numBins = 256;
    threshold = 0.01;
    pixelTommRatio = 0.1;

    originalImage = imread(imagePath);
    preprocessedImage = imresize(originalImage, targetSize);
    
    originalMask = imread(maskPath);
    preprocessedMask = imresize(originalMask, targetSize, 'nearest') > 0;

    % Extract features
    [perimeterLength, compactness, shapeFactor] = extractBorderFeatures(preprocessedMask, false);
    [red, green, blue, colorDiversity] = extractColorVariability(preprocessedImage, preprocessedMask);
    [verticalAsymmetryScore, horizontalAsymmetryScore] = extractAsymmetry(preprocessedImage, preprocessedMask);  % Use both vertical and horizontal scores
    colorHistograms = extractColorHistograms(preprocessedImage, preprocessedMask, numBins);
    colorDiversity = estimateColorDiversityFromHistograms(colorHistograms, threshold);
    [maxDiameterPixels, ~] = calculateDiameter(preprocessedMask);
    maxDiameterMm = maxDiameterPixels * pixelTommRatio;
    textureHeterogeneity = calculateHeterogeneity(calculateLBPFeatures(preprocessedImage, preprocessedMask));
    [morphMask, lesionArea, perimeter, eccentricity, solidity] = processMorphologicalFeatures(preprocessedMask);

    features = [verticalAsymmetryScore, horizontalAsymmetryScore, perimeterLength, compactness, shapeFactor, maxDiameterMm, colorDiversity, textureHeterogeneity, lesionArea, perimeter, eccentricity, solidity];

    % Predict the class using the SVM model
    [predictedLabel, ~] = predict(svmModel, features);

    figure;
    imshow(originalImage);
    hold on;
    [~, lesionName, ~] = fileparts(imagePath);
    lesionClass = 'Malignant';
    if strcmp(predictedLabel{1}, 'benign')
        lesionClass = 'Benign';
    end
    title(['Lesion: ', lesionName, ' - ', lesionClass]);

    annotationString = sprintf('A: %.2f (V), %.2f (H)\nB: %.2f\nC: %.2f\nD: %.2f mm\nE (Color Diversity): %.2f\nMorphological (LBP) Score: %.2f', ...
        verticalAsymmetryScore, horizontalAsymmetryScore, compactness, colorDiversity, maxDiameterMm, textureHeterogeneity);
    text(10, 10, annotationString, 'Color', 'yellow', 'FontSize', 12, 'VerticalAlignment', 'top', 'BackgroundColor', 'black', 'Interpreter', 'none');

    hold off;
end
