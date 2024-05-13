function [imds,mads, groundtruth] = loadData(imPath, maPath, laPath)
    imds = imageDatastore(imPath,"LabelSource",'foldernames');
    mads = imageDatastore(maPath,"LabelSource","foldernames");
    load(laPath,"groundtruth");
    if numel(imds.Files)~= numel(mads.Files) || numel(imds.Files) ~= numel(groundtruth)
        error('Number of images,masks, and labels do not match');
    end
end
