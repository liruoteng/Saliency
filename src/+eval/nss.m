function score = nss(saliencyMap, eyeData)
    mapMean = mean2(saliencyMap);
    mapStd = std2(saliencyMap);
    if mapStd == 0
        mapStd = 1;
    end
    saliencyMap = (saliencyMap - mapMean) / mapStd;
    score = mean(saliencyMap(eyeData.fixInd));
end
