%lmeds_example2
%
%   for testing lmeds on fitting a fundamental matrix through a number of noisy
%   corresponding points (with outliers). 
%
%September 2003.
%
%Copyright Du Huynh
%The University of Western Australia
%School of Computer Science and Software Engineering

% read in the image pair and corresponding points
imfile1 = kb_input('File name of first  image (default=''calib1.jpg''): ', 'calib1.jpg');
im1 = imread(imfile1);
imfile2 = kb_input('File name of second image (default=''calib2.jpg''): ', 'calib2.jpg');
im2 = imread(imfile2);

datfile1 = kb_input('Enter the file name of the first set of feature points (default=''calib1.dat''): ', 'calib1.dat');
xx1 = load(datfile1);
datfile2 = kb_input('Enter the file name of the second set of feature points (default=''calib2.dat''): ', 'calib2.dat');
xx2 = load(datfile2);


% Notes:
% (1) xx1 and xx2 should both be of size n-by-2 matrices, with one image point per row.
%     Here n is the number of corresponding points and, for the estimation of the
%     fundamental matrix, n >= 7.  In the code for rectification, we follow the
%     convention that each column contains an image point in homogeneous coordinates.
% (2) xx1 and xx2 should be in x-y coordinates, with the origin of the image coordinate
%     system at the top-left corner and y-axis pointing down.  For the computation
%     that follows, we need to convert the image coordinate system to be origined
%     at the centre of the image buffer with the y-axis pointing down.

% number of matching points
no_matches = size(xx1,1);

% operations for note (1) above
x1 = [xx1 ones(size(xx1,1), 1)]';
x2 = [xx2 ones(size(xx2,1), 1)]';
% operations for note (2) above
siz = size(im1);
origin = [siz(2); siz(1)]/2;

% axes for plotting the images later on
axis_x = -origin(1) : (origin(1)-1);
axis_y = (origin(2)-1): -1 : -origin(2);

% T is the 3-by-3 transformation matrix required for operation (2) above
T = [1 0 -origin(1); 0 -1 origin(2); 0 0 1];
x1 = T*x1;
x2 = T*x2;
xy1xy2 = [x1; x2];

sigma = kb_input('Estimate of inlier noise level (default=1)? ', 1);
% since we are working on real image pair in this example, no need to add
% noise to inlier

prop_outliers = kb_input('Proportion of outliers in data (default=0.3)? ', 0.3);

% generate indices for inliers and outliers
no_outliers = round(prop_outliers*no_matches);
outlier_idx = randperm(no_matches);
outlier_idx = outlier_idx(1:no_outliers);
inlier_idx = setdiff((1:no_matches)', outlier_idx);

xmin = min(min(xy1xy2([1,4],:))); xmax = max(max(xy1xy2([1,4],:)));
ymin = min(min(xy1xy2([2,5],:))); ymax = max(max(xy1xy2([2,5],:)));
outliers = [rand(2,no_outliers)*(xmax-xmin-1) + xmin; 
   rand(2,no_outliers)*(ymax-ymin-1) + ymin];
% replace some inliers with outliers
xy1xy2([1,4],outlier_idx) = outliers(1:2,:);
xy1xy2([2,5],outlier_idx) = outliers(3:4,:);

% call lmeds to get the best fitted fundamental matrix.  The last argument
options = lmeds_options('func', 'fundmatrix_nonlin', ...
   'prop_outliers', prop_outliers, ...
   'inlier_noise_level', sigma, ...
   'prob', 0.9999);
[F,comp_inlier_idx,comp_outlier_idx,errs,avgerr] = lmeds(xy1xy2, options, 'fundmatrix_condfunc');

% epipolar lines in image 1
x1 = xy1xy2(1:3,:);
x2 = xy1xy2(4:6,:);
line1 = F'*x2(:,comp_inlier_idx);
line2 = F*x1(:,comp_inlier_idx);

% plotting...
fig = figure; hold on
imagesc(axis_x, axis_y, im1);
colormap gray
% draw epipolar lines
draw_2d_line(line1, [min(axis_x),min(axis_y),max(axis_x),max(axis_y)], fig, 'y-');
tmp = plot(x1(1,inlier_idx), x1(2,inlier_idx), 'g.', ...
   x1(1,outlier_idx), x1(2,outlier_idx), 'r*', ... 
   x1(1,comp_inlier_idx), x1(2,comp_inlier_idx), 'bd');
legend(tmp, 'Synthesized inliers', 'Synthesized outliers', 'Detected inliers');
title('First image');

fig = figure; hold on
imagesc(axis_x, axis_y, im2);
colormap gray
% draw epipolar lines
draw_2d_line(line2, [min(axis_x),min(axis_y),max(axis_x),max(axis_y)], fig, 'y-');
tmp = plot(x2(1,inlier_idx), x2(2,inlier_idx), 'g.', ...
   x2(1,outlier_idx), x2(2,outlier_idx), 'r*', ... 
   x2(1,comp_inlier_idx), x2(2,comp_inlier_idx), 'bd');
legend(tmp, 'Synthesized inliers', 'Synthesized outliers', 'Detected inliers');
title('Second image');

fprintf('False negative\n');
fprintf('The following inliers were wrongly classified as outliers:\n');
fprintf('%s\n', num2str(setdiff(inlier_idx, comp_inlier_idx)));
fprintf('\n');

fprintf('False positive\n');
fprintf('The following outliers were wrongly classified as inliers:\n');
fprintf('%s\n', num2str(setdiff(comp_inlier_idx, inlier_idx)));
fprintf('\n');

