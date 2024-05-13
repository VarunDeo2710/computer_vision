function colorDiversity = estimateColorDiversityFromHistograms(colorHistograms,threshold)
    significantBins = sum(colorHistograms > threshold, 1);
    colorDiversity = sum(significantBins);
end