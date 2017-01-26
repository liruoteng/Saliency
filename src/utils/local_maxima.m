function result = local_maxima(image,range)
% this function calculate the local maxima according to Itti'98 paper.
%
% INPUT: 
%   image: input feature map
%   range: normalization range (minimum, maximum)
%
% OUTPUT: 
%   result: normalized feature map

if isempty(range) == 1
    range = [0 10];
end

image = scale_normalize(image,range);
maximal = max(max(image));
minimal = min(min(image));
threshold = (maximal - minimal)/10 + minimal;
idx = imregionalmax(image);
idx = idx & (image >= threshold);
avg = mean(image(idx(:)));
num = numel(image(idx(:)));

if (num > 1)
  result = image * (max(range) - avg)^2;
elseif (num == 1)
  result = image * max(range)^2;
else
  error('Could not find any local maxima.');
end
