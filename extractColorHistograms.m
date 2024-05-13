function colorHistograms = extractColorHistograms(segmentedImage, binaryMask, numBins)
    binaryMask = logical(binaryMask);
    colorHistograms = zeros(numBins, 3);

    for channel = 1:3
        % Extract the color channel using the mask
        channelData = segmentedImage(:,:,channel);
        maskedChannelData = channelData(binaryMask);

        [counts, ~] = imhist(maskedChannelData, numBins);
        
        colorHistograms(:, channel) = counts / sum(counts);
    end
end