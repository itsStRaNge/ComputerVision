%trifocal_6pts_example2
%
%   This m file demonstrates how to call the function trifocal_6pts via lmeds
%   when the image data contain outliers
%
%   SEE ALSO trifocal_6pts_example1
%
%Created by Du Huynh, January 2004.
%
%Copyright Du Huynh
%The University of Western Australia
%School of Computer Science and Software Engineering

format compact

datfile = kb_input('Name of the .mat file that contains the image data (default=''data.mat''): ', 'data.mat');
load(datfile);

noViews = size(xind,2);
fprintf('Number of camera views = %d\n', noViews);

xi = [];
for i=1:noViews
   truexi(:,:,i) = plockaurml(x,xind,i);
end
noPoints = size(truexi,2);
fprintf('Number of points = %d\n\n\n', noPoints);

% Note that sigma should be kept small for all outliers to be successfully detected.
sigma = kb_input('Estimate of inlier noise level (default=0.1)? ', 0.1);

% add inlier noise
inlier_noise = randn(2,noPoints, noViews)*sigma;
xi = truexi;
xi(1:2,:,:) = truexi(1:2,:,:) + inlier_noise;

prop_outliers = kb_input('Proportion of outliers in data (default=0.3)? ', 0.3);

% generate indices for inliers and outliers
no_outliers = round(prop_outliers*noPoints);
outlier_idx = randperm(noPoints);
outlier_idx = outlier_idx(1:no_outliers);
inlier_idx = setdiff((1:noPoints)', outlier_idx);

xmin = min(min(xi(1,:,:))); xmax = max(max(xi(1,:,:)));
ymin = min(min(xi(2,:,:))); ymax = max(max(xi(2,:,:)));

outliers = [rand(1,no_outliers,noViews)*(xmax-xmin-1) + xmin; 
   rand(1,no_outliers,noViews)*(ymax-ymin-1) + ymin];
% replace some inliers with outliers
xi(1:2,outlier_idx,:) = xi(1:2,outlier_idx,:) + outliers;

% call lmeds to get the best fitted fundamental matrix.  The last argument
options = lmeds_options('func', 'trifocal_6pts', ...
   'prop_outliers', prop_outliers, ...
   'inlier_noise_level', sigma, ...
   'prob', 0.9999);

% prepare data for lmeds - stack all the image points together.
xx = [];
for i=1:noViews
   xx = [xx; xi(:,:,i)];
end

[T, det_inlier_idx, det_outlier_idx, errs, avgerr] = lmeds(xx, options);

fprintf('The estimated trifocal tensor is:\n'); T
fprintf('\n')
fprintf('The squared reprojection errors of all correspondences are:\n'); errs
fprintf('\n');
fprintf('The squared reprojection errors of the inliers only are:\n'); errs(det_inlier_idx)
fprintf('\n');
fprintf('Detected inlier indices are:\n'); det_inlier_idx
fprintf('True inlier indices are:\n'); inlier_idx
fprintf('\n\n');
fprintf('False positive? indices are:\n'); false_pos = setdiff(det_outlier_idx, outlier_idx)
fprintf('The estimated squared reproj. errors of false positives:\n'); errs(false_pos)
fprintf('Difference between true and noisy coordinates for the false positives:\n');
truexi(:,false_pos,:) - xi(:,false_pos,:)
fprintf('\n\n');
fprintf('False negative? indices are:\n'); false_neg = setdiff(outlier_idx, det_outlier_idx)
fprintf('The estimated squared reproj. errors of false negatives:\n'); errs(false_neg)
fprintf('Difference between true and noisy coordinates for the false negatives:\n');
truexi(:,false_neg,:) - xi(:,false_neg,:)
fprintf('\n');

more off
