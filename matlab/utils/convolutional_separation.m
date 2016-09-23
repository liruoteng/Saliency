function result = convolutional_separation(filter1,filter2,data)

[Height,Width] = size(data);

% 2d convolution with zero padding from Matlab
result = conv2(filter1,filter2,data,'same');

% Vertical filter length
filter_length_vertical = length(filter1);
filter_half_vertical = floor((filter_length_vertical-1)/2);
% Horizontal filter
filter_length_horizontal = length(filter2);
filter_half_horizontal = floor((filter_length_horizontal-1)/2);

% Cumulate filters
filter_cumulate_vert1 = cumsum(filter1);
filter_cumulate_vert2 = cumsum(filter1(end:-1:1));
filter_sum1 = sum(filter1);
filter_cumulate_hori1 = cumsum(filter2);
filter_cumulate_hori2 = cumsum(filter2(end:-1:1));
filter_sum2 = sum(filter2);


% The filter is convoluted with the image on top, bottom, left, and right
filter_verticle_1 = repmat(filter_cumulate_vert1(filter_half_vertical+1:end-1)',1,Width);
result(1:filter_half_vertical,:) = result(1:filter_half_vertical,:) * filter_sum1 ./ filter_verticle_1;

filter_verticle_2 = repmat(filter_cumulate_vert2(filter_half_vertical+1:end-1)',1,Width);
result(end:-1:end-filter_half_vertical+1,:) = result(end:-1:end-filter_half_vertical+1,:) * filter_sum1 ./ filter_verticle_2;

filter_horizon_1 = repmat(filter_cumulate_hori1(filter_half_horizontal+1:end-1),Height,1);
result(:,1:filter_half_horizontal) = result(:,1:filter_half_horizontal) * filter_sum2 ./ filter_horizon_1;

filter_horizon_2 = repmat(filter_cumulate_hori2(filter_half_horizontal+1:end-1),Height,1);
result(:,end:-1:end-filter_half_horizontal+1) = result(:,end:-1:end-filter_half_horizontal+1) * filter_sum2 ./ filter_horizon_2;
end
