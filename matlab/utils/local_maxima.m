function result = local_maxima(image,range)

if isempty(range) == 1
    range = [0 10];
end

image = scale_normalize(image,range);

idx = imregionalmax(image);
lm_avg = mean(image(idx(:)));
lm_num = numel(image(idx(:)));

if (lm_num > 1)
  result = image * (max(range) - lm_avg)^2;
elseif (lm_num == 1)
  result = image * max(range)^2;
else
  error('Could not find any local maxima.');
end
