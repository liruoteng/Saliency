function result = scale_normalize(image, range)
% this function provide scaling operation on the input image
% 
% INPUT: 
%   image: feature map
%   range: normalization range (minimum, maximum)
%
% OUTPUT: 
%   result: normalized feature map

if isempty(range) == 1
    range = [0,1];    
end

maximum = max(image(:));
minimum = min(image(:));
average = sum(range) / 2;
old_variance = maximum - minimum;
new_variance = abs(range(2) - range(1));

if maximum == minimum
    result = image + average - maximum;
else
    result = (image - minimum) / old_variance * new_variance + min(range);
end
