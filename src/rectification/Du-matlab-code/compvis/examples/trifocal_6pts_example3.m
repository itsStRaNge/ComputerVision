%trifocal_6pts_example3
%
%   This m file demonstrates how to call the functions trifocal_6pts,
%   projmatrix_from_trifocal, and triangulation
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
[val(1),val(2),val(3)] = deal(avgerr_{:});
[minval,minidx] = min(val);
fprintf('We select the solution that has the smallest average squared reprojection error.\n');
T = T_{minidx};
errs = errs_{minidx};
avgerr = avgerr_{minidx};

estP = projmatrix_from_trifocal(T);

estX = triangulate(estP, [xx(:,:,1); xx(:,:,2); xx(:,:,3)]);
fprintf('The reconstructions (up to an unknown projective transformation) are:\n'); estX
fprintf('\n');

% compute the reprojection errors
for i=1:noViews
   xhat(:,:,i) = pflat(estP(:,:,i)*estX);
   fprintf('Variable xhat contains the reprojected image points.\n');
   fprintf('Variable xx contains the detected image points.\n');
   fprintf('Differences of image coordinates between the two in image %d are: ', i);
   xhat(:,:,i) - xx(:,:,i)
end

more off
