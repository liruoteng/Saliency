function result = differenceOfGaussian(image, iter, range)

if isempty(range) == 1
    range = [0,10];
end

% i Each feature map is normalized to a fixed range
image = max(image, 0);
result = scale_normalize(image, range);

sigma_excited = 0.02;
sigma_inhibitory = 0.25;
C_inhibitory = 1.5;
C_excited = 0.5;
G_inhibition = 0.02;

L = max(size(result));  % find the length of large kernel
% Find the size of the gaussian kernel
kernel_width_exc = L * sigma_excited;
kernel_width_inh = L * sigma_inhibitory;
max_width = max(0, floor(min(size(result))/2) - 1);
gauss_mean_excited = C_excited / (kernel_width_exc * sqrt(2*pi));
gauss_mean_inhibitory = C_inhibitory / (kernel_width_inh * sqrt(2*pi));
gaussian_1d_exc = gaussian(gauss_mean_excited, kernel_width_exc, max_width);
gaussian_1d_inh = gaussian(gauss_mean_inhibitory, kernel_width_inh, max_width);


% ii. Each resultant map is convolved by Gaussian filter
kernel_size = max(size(result));

for i = 1:iter
    
    excitation = sepConv2PreserveEnergy(gaussian_1d_exc,gaussian_1d_exc,result);
    inhibition = sepConv2PreserveEnergy(gaussian_1d_inh,gaussian_1d_inh,result);
    
    
    global_inihibition = G_inhibition * max(result(:));
    result = result + excitation - inhibition - global_inihibition;

end

