%lmeds_example1
%
%   for testing lmeds on fitting a line through a number of noisy
%   points (with outliers). 
%
%September 2003.
%
%Copyright Du Huynh
%The University of Western Australia
%School of Computer Science and Software Engineering


% create two seed points
pt = [rand(1,1)*100-50, rand(1,1)*100+80; rand(1,2)*230-50];
npts = kb_input('Total number of 2D points (default=100)? ', 100);
alpha = rand(1,npts);
% create points that are linear combination of the two seed points.
% These points are collinear on the 2D plane.
xy = zeros(3,npts);
xy(1:2,:) = pt(:,1)*alpha + pt(:,2)*(1-alpha);
xy(3,:) = ones(1,npts);
[abc_true,err_true] = fitline_ls(xy, []);

sigma = kb_input('Level (sigma) of small Gaussian noise added to inliers (default=0.2)? ', 0.2);
% small Gaussian noise (zero mean, standard deviation=sigma)
noise = randn(2,npts)*sigma;
% add small noise to inliers
xy(1:2,:) = xy(1:2,:) + noise;

prop_outliers = kb_input('Proportion of outliers in data (default=0.3)? ', 0.3);
no_outliers = round(prop_outliers*npts);
outlier_idx = round(rand(no_outliers,1)*(npts-1) + 1);
inlier_idx = setdiff((1:npts)', outlier_idx);

xmin = min(xy(1,:)); xmax = max(xy(1,:)); ymin = min(xy(2,:)); ymax = max(xy(2,:));
outliers = [rand(1,no_outliers)*(xmax-xmin-1) + xmin; 
   rand(1,no_outliers)*(ymax-ymin-1) + ymin];
% replace some inliers with outliers
xy(1:2,outlier_idx) = outliers;

% call lmeds to get the best fitted line.  The last argument (the number of points
% per sample below is 2 as we need two points to fit a line.

options = lmeds_options('func', 'fitline_ls', 'prop_outliers', prop_outliers, ...
   'inlier_noise_level', sigma);

[abc,comp_inlier_idx,comp_outlier_idx,errs] = lmeds(xy, options, 'fitline_condfunc');
xlist = linspace(min(xy(1,:)), max(xy(1,:)), 10);

ylist_true = -(abc_true(1)*xlist + abc_true(3)) / abc_true(2);
ylist = -(abc(1)*xlist + abc(3)) / abc(2);

fig=figure; hold on
plot(xy(1,inlier_idx), xy(2,inlier_idx), 'g.', ...
   xy(1,outlier_idx), xy(2,outlier_idx), 'r*', ... 
   xy(1,comp_inlier_idx), xy(2,comp_inlier_idx), 'bd', ...
   xlist, ylist_true, 'k-', xlist, ylist, 'r-');
legend('Synthesized inliers', 'Synthesized outliers', 'Detected inliers', ...
   'true line', 'fitted line');
title('Line fitting example');
grid on
