%recons_2views_example
%
%   showing how to call the following functions: fundmatrix_ls, recons_2views
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
fprintf('number of camera views = %d\n', noViews);

for i=1:noViews
   % variable xx contains the correspondences
   xx(:,:,i) = plockaurml(x,xind,i);
end

% estimate the fundamental matrix using the 8 point algorithm
estF = fundmatrix_ls([xx(:,:,1); xx(:,:,2)], [], []);
fprintf('The estimated fundamental matrix is: \n'); estF

fprintf('Inspect the output argument errs below, which contains the squared\n');
fprintf('reprojection errors of all the reconstructed world points\n');
[estX, estP, errs, avgerr] = recons_2views([xx(:,:,1); xx(:,:,2)], estF)
