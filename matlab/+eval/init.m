function eyeData = init(db, images)
    nImages = length(images);
    eyeData = cell(1, nImages);

    load(fullfile('../data', db, 'eye.mat'));

    imageSize = [480, 640];

    for i=1:nImages
        coord = fixations{i}.coord;
        eyeData{i}.fixInd = sub2ind(imageSize, coord(:,1), coord(:,2));
    end
    
    allFix = [eyeData{:}];
    allFixInd = unique(vertcat(allFix.fixInd));
    for i=1:nImages
        eyeData{i}.restFixInd = setdiff(allFixInd, eyeData{i}.fixInd);
    end
end
