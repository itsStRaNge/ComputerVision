function [H,errs,sval,sval_ratio] = homography_old(ptset1, ptset2, idx, scale)

%HOMOGRAPHY_OLD returns the plane homography of two sets of image points
%
%   H = homography_old(ptset1, ptset2)
%   [H,errs,sval,sval_ratio] = homography_old(ptset1, ptset2, idx, scale)
% 
%   Returns the homography, H, between two sets of points in general position
%   on two planes under a perspective centre.  The computed homography, H,
%   satisfies the equation (for all matching points in ptset1 and ptset2):
%          [x1]     [x2]
%      H * [y1]  ~  [y2]
%          [z1]     [z2]
%   where [x1,y1,z1]' and [x2,y2,z2]' are corresponding column vectors in
%   ptset1 and ptset2 respectively, and ~ denotes equality up to a scale.
%
%   Input arguments:
%   - ptset1 and ptset2 should both be 3-by-n matrix, where n >= 4.
%     The corresponding column vectors in both matrices should store the
%     matching image points (in homogeneous coordinates) in the two sets.
%   - idx (optional argument) should be an array of indices.  If idx is not
%     specified or if idx=[] then all the points given in ptset1 and ptset2
%     would be used for computing H, otherwise, only ptset1(:,idx) and
%     ptset2(:,idx) would be considered.
%   - scale (optional argument) should be either 0 or 1 to denote whether
%     scaling should be performed to enforce the x, y, and z components of
%     the points to have similar magnitudes.  If not specified, no scaling
%     would be performed.
%     If this function is used for testing whether the points in ptset1 and
%     ptset2 are projections of coplanar scene points, then set scale=0
%     or do not specify this argument.
%
%   Output arguments:
%   - H is the computed 3-by-3 homography matrix.
%   - errs (optional argument) is an n-array of errors, one for each correspondence.
%   - sval (optional argument) is the smallest singular value involved in
%     estimating H.  This value gives some indication about how well is the
%     estimate of H.
%   - sval_ratio (optional argument) is the ratio between the smallest singular
%     value and the next smaller singular value.  This value also gives
%     some indication about how well is the estimate of H.
%     
%Created October 1996.
%Revised May 1997, October 2003, January 2004.
%
%Copyright Du Huynh
%The University of Western Australia
%School of Computer Science and Software Engineering

n = size(ptset1,2);
if nargin < 3
   idx = 1:n;
elseif isempty(idx)
   idx = 1:n;
end

pt1 = ptset1(:,idx);
pt2 = ptset2(:,idx);
len = length(idx);

if ~all(size(ptset1)==size(ptset2))
   error('homography_old: ptset1 and ptset2 must both be of the same size');
elseif size(ptset1,1) ~= 3
   error('homography_old: ptset1 and ptset2 must be 3-by-n matrices');
elseif len < 4
   error('homography_old: a minimum of 4 correspondences are required to compute H');
end

% scaling
if nargin > 3 & scale == 1
   mag3 = range([pt1(3,:), pt2(3,:)]) + 1;
   mat = [pt1(1:2,:) pt2(1:2,:)];
   mag12 = range(mat(:)) + 1;
   scale = mag3 / mag12;
   T = diag([scale scale 1]);
else
   T = eye(3);
end
x1 = T*pt1;
x2 = T*pt2;

% each correspondence in the two matrices contributes 2 equations
A = zeros(2*len, 9);
A(1:2:(2*len-1), 1:3) = diag(x2(3,:))*x1';
A(1:2:(2*len-1), 7:9) = -diag(x2(1,:))*x1';
A(2:2:2*len, 4:6) = diag(x2(3,:))*x1';
A(2:2:2*len, 7:9) = -diag(x2(2,:))*x1';

% elements of H (represented in a 9-vector h) is then
[h,sval1,sval_ratio1] = lsq(A);

H = reshape(h,3,3)';

% need to rescale H back...
H = inv(T)*H*T;
H = H / norm(H,2);

if nargout > 1
   x2 = pflat(H*ptset1);
	ptset2 = pflat(ptset2);
   errs = sqrt( sum((ptset2(1:2,:) - x2(1:2,:)).^2, 1) );
end
if nargout > 2, sval = sval1; end;
if nargout > 3, sval_ratio = sval_ratio1; end;

return

