function gf = gabor_filter(bw, theta, lambda, psi, gamma)
% this function generate gabor filter kernel with corresponding parameters
% as input. 
%
% INPUT: 
%   bw: bandwidth
%   theta: orientation
%   
% OUTPUT: 
%   gf: gabor filter kernel
%
% if not provide advanced paramter sets

if nargin < 3
    lambda = 4;
    psi = 0;
    gamma = 0.5;
end

sigma = lambda/pi*sqrt(log(2)/2)*(2^bw+1)/(2^bw-1);
sigma_x = sigma;
sigma_y = double(sigma)/gamma;

% bounding box
sz=fix(8*max(sigma_y,sigma_x));
if mod(sz,2)==0, sz=sz+1;end
[x, y]=meshgrid(-fix(sz/2):fix(sz/2),fix(sz/2):-1:fix(-sz/2));

% nstds = 3;
% xmax = max(abs(nstds*sigma_x*cos(theta)), abs(nstds*sigma_y*sin(theta)));
% xmax = ceil(max(1, xmax));
% ymax = max(abs(nstds*sigma_x*sin(theta)), abs(nstds*sigma_y*cos(theta)));
% ymax = ceil(max(1, ymax));
% xmin = -xmax; ymin = -ymax;
% [x,y] = meshgrid(xmin:xmax, ymin:ymax);


% Rotation 
x_theta=x*cos(theta)+y*sin(theta);
y_theta=-x*sin(theta)+y*cos(theta);
 
gf=exp(-0.5*(x_theta.^2/sigma_x^2+y_theta.^2/sigma_y^2)).*cos(2*pi/lambda*x_theta+psi);
end
