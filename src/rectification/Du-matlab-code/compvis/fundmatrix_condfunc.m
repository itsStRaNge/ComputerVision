function ok = fundmatrix_condfunc(data)

%FUNDMATRIX_CONDFUNC checks condition of input data.
%
%   ok = fundmatrix_condfunc(data)
%
%   When a random sample of data points is chosen for estimating
%   the fundamental matrix, this function should be used to inspect
%   for possible degeneracy of the sample.  Two degenerate conditions
%   are checked by the function:
%   (1) checking for the scattering of the feature points in both images.
%       A minimum distance of 15 pixels between data points is enforced.
%   (2) checking for possible coplanarity of the scene points.  If the
%       image data points in the sample are projections of scene points
%       that are coplanar in space then the sample is considered to be
%       degenerate.
%
%   fundmatrix_condfunc should be used in conjunction with lmeds and
%   one of the function for fundamental computation.  The current version
%   of fundmatrix_condfunc only checks for the minimum distance among
%   data points in the image.
%     
%   SEE ALSO fundmatrix_ls, fundmatrix_nonlin, fundmatrix_wls,
%            fitline_ls, fitplane_ls, lmeds_options
%
%Created 2000.
%Revised September 2003.
%
%Copyright Du Huynh
%The University of Western Australia
%School of Computer Science and Software Engineering

if size(data,1) ~= 6 & size(data,2) < 7
   error('fundmatrix_condfunc: data must have 6 rows and at least 7 columns');
end

xy1 = pflat(data(1:3,:));
xy2 = pflat(data(4:6,:));
xy = [xy1(1:2,:); xy2(1:2,:)];
no_pts = size(xy,2);

% checking of condition (1)
ok = 1;
for i=1:no_pts
   diff = (xy - xy(:,i)*ones(1,no_pts)).^2;
   diff = diff(:, [1:(i-1), (i+1):no_pts]);
   if any( sum(diff(1:2,:), 1) < 225 ) | ...  % note 225 = 15^2
         any( sum(diff(3:4,:), 1) < 225 )
      ok = 0;
      break;
   end
end

if ok == 1
   % checking of condition (2)
   [estH,sval,sval_ratio] = homography(data(1:3,:), data(4:6,:));
   if sval < 0.1 | sval_ratio < 0.1
      ok = 0;
   end
end

return
