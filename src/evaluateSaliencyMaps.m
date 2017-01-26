clear all

datasets = {'example', 'validation'};

for iDb = 1:length(datasets)
    db = datasets{iDb};
    load(fullfile('..', 'data', db, 'images.mat'));

    % initialization
    eyeData = eval.init(db, images);
    nssScores = zeros(size(images));
    saucScores = zeros(size(images));
    
    % for each image
    for iImage = 1:length(images)
        % read the saliency map
        saliencyMap = im2double(imread(fullfile('..', 'results', db, images{iImage})));
                
        % calculate the NSS and the shuffled AUC scores
        nssScores(iImage) = eval.nss(saliencyMap, eyeData{iImage});
        saucScores(iImage) = eval.sauc(saliencyMap, eyeData{iImage});
    end
    
    % print the average scores
    fprintf('\nPerformance on the %s set:\n', db);
    fprintf('SAUC\t= %.3f\n', mean(saucScores));
    fprintf('NSS\t= %.3f\n', mean(nssScores));
end
