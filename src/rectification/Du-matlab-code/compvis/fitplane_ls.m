function [abcd, errs, avgerr] = fitplane_ls(xyzset, idx, scale)

%FITPLANE_LS fits a plane to a number of 3D points.
%
%   abcd = fitplane_ls(xyz, idx)
%   abcd = fitplane_ls(xyz, idx, scale)
%   [abcd, errs] = fitplane_ls(xyz, idx)
%   [abcd, errs] = fitplane_ls(xyz, idx, scale)
%   [abcd, errs, avgerr] = fitplane_ls(xyz, idx)
%   [abcd, errs, avgerr] = fitplane_ls(xyz, idx, scale)
%
%   returns the coefficients, a, b, c, and d, of the plane
%      ax + by + cz + d = 0
%   that best fits a 3D points.
%   
%   Input arguments:
%   - xyz must be a 4-by-n matrix where each column of the matrix stores
%     one 3D point represented in homgeneous coordinates, and n must be
%     greater than or equal to 3.
%   - idx must be an array of integers in the range [1,n].  If idx=[] then
%     all the data points (i.e. columns) in xyzset would be used for
%     plane fitting.
%   - scale is an optional argument and, if specified, should be just 0
%     (to denote no scaling) and 1 to denote scaling.  By default, some
%     scaling would be applied to the data points prior to computing
%     the least-squares solution.  As a comparison, try the function
%     with and without scaling to see the slight difference in the fitting
%     (a smaller or larger average fitting error, for instance).
%
%   Output arguments:
%   - abcd is the vector storing the four coefficients, a, b, c, and d, of
%     the plane.  Here, abcd(1) = a;  abcd(2) = b;  abcd(3) = c; abcd(4) = d.
%   - errs (optional) stores the array of errors of the plane fitting to all
%     the data points in xyzset:
%        errs = sum_{i=1}^n |a*x_i + b*y_i + c*z_i + d | /  sqrt(a^2+b^2+c^2)
%   - avgerr (optional) stores the average value of errs
%
%   fitplane_ls employs the linear least squares method to get an approximation
%   of the coefficients.  More advanced methods will be implemented in the
%   future.
%
%   SEE ALSO fitplane, lmeds, ransac
%
%Ceated August 1996
%Revised December 1999
%Revised September 2003
%
%Copyright Du Huynh
%The University of Western Australia
%School of Computer Science and Software Engineering

% check dimensions of input argument
if isempty(idx)
   % the user doesn't care about the list idx, so will use all
   % data points
   idx = 1:size(xyzset,2);
   xyz = xyzset;
elseif any(idx <= 0 | idx > size(xyzset,2))
   error('fitplane: idx must be an array of integers in the range [1,n], where n=size(xyzset,2).');
else
   xyz = xyzset(:,idx);
end

if size(xyz,1) ~= 4 | length(idx) < 3
   error('fitplane: xyz must be a 4-by-n matrix, with n >= 3.');
end

if nargin == 2, scale = 1; end
if scale
   xyz_old = xyz;
   xyz = pflat(xyz);
   range = max(xyz(1:3,:),[],2) - min(xyz(1:3,:),[],2);
   range(find(range < eps)) = 1;
   T = diag([sqrt(2)./range; 1]);
   xyz = T*xyz;
end

A = xyz*xyz';
abcd = lsq(A);
if scale
   % undo the scaling
   abcd = T'*abcd;
   abcd = abcd / norm(abcd,2);
   % restore xyz
   xyz = xyz_old;
end

if nargout > 1
   errs = abs(abcd'*xyz) / sqrt(sum(abcd(1:3).^2));
end
if nargout > 2
   avgerr = mean(errs);
end

return

