clear all

datasets = {'example'};

for iDb = 1:length(datasets)
    db = datasets{iDb};
    load(fullfile('..', 'data', db, 'images.mat'));

    fprintf('\nComputing saliency maps for the %s set.\n', db);

    % for each image
    for iImage = 1:length(images)
        % read the RGB image
        image = imread(fullfile('..', 'data', db, images{iImage}));
        
        % compute the saliency map
        saliencyMap = saliencyAlgorithm(image);
        
        % resize the saliency map
        [height, width, ~] = size(image);
        saliencyMap = imresize(saliencyMap, [height, width]);

        % normalize the map values to [0, 1]
        saliencyMap = saliencyMap - min(saliencyMap(:));
        if max(saliencyMap(:)) > 0
            saliencyMap = saliencyMap / max(saliencyMap(:));
        end
 
        % save the result
        if exist('../results/example', 'dir') ~= 7
            mkdir '../results/example';
        end
        imwrite(saliencyMap, fullfile('..', 'results', db, images{iImage}));
    end
end