%trifocal_6pts_example1
%
%   This m file demonstrates how to call the functions trifocal_6pts and trifocal_pt_transfer
%
%Created by Du Huynh, January 2004.
%
%Copyright Du Huynh
%The University of Western Australia
%School of Computer Science and Software Engineering

more on
format compact

datfile = kb_input('Name of the .mat file that contains the image data (default=''data.mat''): ', 'data.mat');
load(datfile);

fprintf('\nFile %s contains the following variables:\n', datfile);
whos

noViews = size(xind,2);
fprintf('Number of camera views = %d\n', noViews);

for i=1:noViews
   % variable xx contains the correspondences
   xx(:,:,i) = plockaurml(x,xind,i);
end
noPoints = size(xx,2);
fprintf('Number of points = %d\n\n\n', noPoints);

% randomly select 6 points to be used as basis points
tmp = randperm(noPoints);
idx = tmp(1:6);
[T_, errs_, avgerr_] = trifocal_6pts([xx(:,:,1); xx(:,:,2); xx(:,:,3)], idx);

fprintf('Number of solutions = %d\n', length(T_));
for i=1:length(T_)
   fprintf('*** Solution %d:\n', i);
   fprintf('The estimated trifocal tensor is:\n');
   T = T_{i}
   fprintf('The squared reprojection errors are:\n');
   errs = errs_{i}
   fprintf('The average squared reprojection error is:\n');
   avgerr = avgerr_{i}
   [x3hat,x1hat,x2hat] = trifocal_pt_transfer(T, xx(:,:,1), xx(:,:,2));
   fprintf('trifocal_pt_transfer estimated x3hat to be\n');
   x3hat = pflat(x3hat)
   fprintf('Differences between the detected and transferred image points in image 3 are:\n');
   x3hat - xx(:,:,3)
   fprintf('--------------------------------------------------\n');
   pause
end

more off
% Note that if there are 3 solutions then 2 of them can be easily discarded as
% their squared reprojection errors are often very large
