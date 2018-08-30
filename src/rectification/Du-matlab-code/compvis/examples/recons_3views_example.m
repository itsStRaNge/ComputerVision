%recons_3views_example
%
%   This m file demonstrates how to call the following functions: recons_3views
%
%Created by Du Huynh, January 2004.
%
%Copyright Du Huynh
%The University of Western Australia
%School of Computer Science and Software Engineering

more on
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
[estX_, estP_, errs_, avgerr_] = recons_3views([xx(:,:,1); xx(:,:,2); xx(:,:,3)], idx);

fprintf('Number of solutions = %d\n', length(estX_));
for i=1:length(estX_)
   fprintf('Solution %d:\n', i);
   fprintf('The estimated world points are:\n');
   estX = estX_{i}
   fprintf('The estimated projection matrices are:\n');
   estP = estP_{i}
   fprintf('The squared reprojection errors are:\n');
   errs = errs_{i}
   fprintf('The average squared reprojection error is:\n');
   avgerr = avgerr_{i}
   fprintf('--------------------------------------------------\n');
   pause
end

more off
% Note that if there are 3 solutions then 2 of them can be easily discarded as
% their squared reprojection errors are often very large
