function kernel = gaussian(peak,sigma,maxhw,varargin)

if isempty(varargin)
  threshPercent = 1;
else
  threshPercent = varargin{1};
end

hw = floor(sigma * sqrt(-2 * log(threshPercent / 100)));

if ((maxhw > 0) & (hw > maxhw)) 
  hw = maxhw; 
end

if (peak == 0) 
  peak = 1 / (sigma * sqrt(2*pi)); 
end

sig22 = -0.5 / (sigma * sigma);
tmp = peak * exp(- [1:hw].^2 / (2*sigma*sigma));
kernel = [tmp(hw:-1:1) peak tmp];
