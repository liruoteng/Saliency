%% Implement the Itti saliency algorithm with your improvements
function saliencyMap = saliencyAlgorithmImprove(image)
    addpath('utils');
    
    %image = double(imread('COCO.jpg'));
    image = double(image);
    [height, width, ~] = size(image);
    
    % saliencyMap = zeros(height, width);
    Map.original_image = image;
    Map.original_height = height;
    Map.original_width = width;
    Map.bandwidth = 1;  % tunable, little effect
    Map.garbor_orientations = [0,45,90,135];
    Map.features = {'intensity', 'color', 'orientation'};
    % your code here
    %% 1. linear filtering (color, intensity, orientation)
    
    % I.seperate color channel
    red_channel = image(:,:,1);
    green_channel = image(:,:,2);
    blue_channel = image(:,:,3);
    
    % II.obtain intensity image and broadly-tuned color channels
    I0 = (red_channel + green_channel + blue_channel) / 3;   % intensity
    R0 = red_channel - 0.5 * (green_channel + blue_channel);
    G0 = green_channel - 0.5 * (red_channel + blue_channel);
    B0 = blue_channel - 0.5 * (red_channel + green_channel);
    Y0 = 0.5 * (red_channel + green_channel) - 0.5 * abs(red_channel - green_channel) - blue_channel;
    % negative values are set to zero
    R0 = max(R0, 0);
    G0 = max(G0, 0);
    B0 = max(B0, 0);
    Y0 = max(Y0, 0);
    
    % III.obtain gabor filters for four directions
    for orient = Map.garbor_orientations
        Map.garbor_filters = gabor_filter(Map.bandwidth, orient);
    end;
    
    % IV.create feature pyramid space
    Map.intensity = cell(9,1); % Create a list of downsampled intensity feature map
    Map.color = cell(9, 4);    % Create a list of downsampled color feature map
                               % Columns are R,G,B,Y channels respecitvely
    Map.orientation = cell(9,4); % Create a list of downsampled orientation feature map
                                 % Columns are orentation from 0~135 degrees
                                 % respectively
    % V.create pyramids
    for i = 1:9
        % append
        Map.intensity{i} = I0;
        Map.color{i,1} = R0;
        Map.color{i,2} = G0;
        Map.color{i,3} = B0;
        Map.color{i,4} = Y0;
        Map.orientation{i,1} = imfilter(I0, Map.garbor_filters(1));
        Map.orientation{i,2} = imfilter(I0, Map.garbor_filters(2));
        Map.orientation{i,3} = imfilter(I0, Map.garbor_filters(3));
        Map.orientation{i,4} = imfilter(I0, Map.garbor_filters(4));
        % update
        I0 = impyramid(I0, 'reduce');
        R0 = impyramid(R0, 'reduce');
        G0 = impyramid(G0, 'reduce');
        B0 = impyramid(B0, 'reduce');
        Y0 = impyramid(Y0, 'reduce');
    end
    
    %% 2. center-surround difference and normalization
    % I. Prepare intensity, color, orientation feature maps   
    I_maps = cell(6,1);
    RG_maps = cell(6,1);
    BY_maps = cell(6,1);
    orientation_maps = cell(4,6);

    % II. center surround 
    % Regularize all feature maps to level 5 (sigma = 4)
    i = 0;
    sz = [Map.original_height/16, Map.original_width/16];
    for c = [3,4,5]
        for delta = [3,4]
            i = i + 1;
            s = c + delta;
            % Intensity
            I_maps{i} = abs(imresize(Map.intensity{c}, sz, 'nearest') - imresize(Map.intensity{s}, sz, 'nearest'));
            % Color : R-1 G-2 B-3 Y-4
            c_map = imresize(Map.color{c,1} - Map.color{c,2}, sz, 'nearest');
            s_map = imresize(Map.color{s,2} - Map.color{s,1}, sz, 'nearest');
            RG_maps{i} = abs(c_map - s_map);
            c_map = imresize(Map.color{c,3} - Map.color{c,4}, sz, 'nearest');
            s_map = imresize(Map.color{s,4} - Map.color{s,3}, sz, 'nearest');
            BY_maps{i} = abs(c_map - s_map);
            % Orientation Maps
            orientation_maps{1, i} = abs(imresize(Map.orientation{c, 1},sz,'nearest') - imresize(Map.orientation{s, 1}, sz, 'nearest'));
            orientation_maps{2, i} = abs(imresize(Map.orientation{c, 2},sz,'nearest') - imresize(Map.orientation{s, 2}, sz, 'nearest'));
            orientation_maps{3, i} = abs(imresize(Map.orientation{c, 3},sz,'nearest') - imresize(Map.orientation{s, 3}, sz, 'nearest'));
            orientation_maps{4, i} = abs(imresize(Map.orientation{c, 4},sz,'nearest') - imresize(Map.orientation{s, 4}, sz, 'nearest'));
        end
    end
    
    
    %% 3. across-scale combinations and normalization
    % create conspicuity maps
    conspicuity_intensity = zeros(sz);
    conspicuity_color = zeros(sz);
    conspicuity_orient0 = zeros(sz);
    conspicuity_orient45 = zeros(sz);
    conspicuity_orient90 = zeros(sz);
    conspicuity_orient135 = zeros(sz);
    iters = 2;
    % combine across-scale normalized feature maps 
    for level = 1: length(I_maps)
        conspicuity_intensity = conspicuity_intensity + differenceOfGaussian(I_maps{i}, iters,[0,10]);
        conspicuity_color = conspicuity_color + ...
            differenceOfGaussian(RG_maps{i},iters, [0,10]) + differenceOfGaussian(BY_maps{i},iters, [0,10]); 
        conspicuity_orient0 = conspicuity_orient0 + differenceOfGaussian(orientation_maps{1,level},iters, [0,10]);
        conspicuity_orient45 = conspicuity_orient45 + differenceOfGaussian(orientation_maps{2,level},iters, [0,10]);
        conspicuity_orient90 = conspicuity_orient90 + differenceOfGaussian(orientation_maps{3,level}, iters,[0,10]);
        conspicuity_orient135 = conspicuity_orient135 + differenceOfGaussian(orientation_maps{4,level},iters, [0,10]);
    end
    % combine orientation of four directions
    conspicuity_orientation = differenceOfGaussian(conspicuity_orient0, iters,[0,10]) + ...
                              differenceOfGaussian(conspicuity_orient45, iters,[0,10]) + ...
                              differenceOfGaussian(conspicuity_orient90, iters,[0,10]) + ...
                              differenceOfGaussian(conspicuity_orient135, iters,[0,10]);
   
                          
    %% 4. linear combination
    saliency_map = (conspicuity_intensity) * 0.25 + ...
        (conspicuity_color) * 0.25 + ... 
        (conspicuity_orientation) * 0.5;
    gaussian_filter = fspecial('gaussian', 7,7);
    
    saliencyMap = imfilter(saliency_map, gaussian_filter);
end
