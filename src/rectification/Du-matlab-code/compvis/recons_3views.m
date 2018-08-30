function [X, varargout] = recons_3views(x, idx)

%RECONS_3VIEWS computes the projective structures from 3 views.
%
%   X = recons_3views(x)
%   [X, P, errs, avgerr] = recons_3views(x, idx)
%
%   The function computes projective structures using the list of
%   corresponding triplets stored in the argument x.  The selection
%   of triplets for computing the tensor can be specified in the
%   optional argument, idx.  Since the 6 point algorithm (see [1]) is
%   employed, there may be 1 or 3 solutions for both P and X.
%
%   Input arguments:
%   - x must be a 9-by-n matrix where each column contains a corresponding
%     triplet in 3 images being stacked together.  That is, each column
%     has the form (x1,y1,z1,x2,y2,z2,x3,y3,z3)', denoting the matching
%     triplet (x1,y1,z1) <-> (x2,y2,z2) <-> (x3,y3,z3).
%     Here, n must be >= 6.
%   - idx (optional argument) must be an integer array of a minimum length
%     of 6.  This argument allows samples of 6 triplets to be selected
%     for estimating P and X in a RANSAC fashion.  If idx is not given
%     then the first 6 columns of x would be used for computing P and X.
%
%   Output arguments:
%   - X would be a cell array of length 1 or 3, as there may be 1 or 3
%     possible solutions for both P and X.  Each cell element,
%     X{.} would be a 4-by-n matrix containing the projective coordinates
%     of the reconstructed 3D points.
%   - P (optional argument) would be cell array of the same length as X.
%     Each cell element, P{.}, would be a 3-by-4-by-3 matrix, where
%     P{.}(:,:,i) stores the estimted projection matrix for the i-th
%     camera view.
%   - errs (optional argument) would also be a cell array of the same
%     length.  Each cell element would be an array of squared
%     reprojection errors for all the reconstructed world points.
%   - avgerr (optional argument) would be a cell array.  Each cell element
%     contains the average value of the corresponding element of array errs.
%
%   Reference: 
%   [1] R. Hartley and A. Zisserman, "Multiple View Geometry
%       in Computer Vision", Cambridge University Press 2000,
%       Algorithm 19.1, page 493.
%
%January 21 2004 written by Du Huynh.
%
%Copyright Du Huynh
%The University of Western Australia
%School of Computer Science and Software Engineering

% check input arguments
[m,n] = size(x);
if nargin < 2 | isempty(idx)
   idx = 1:6;
end
len = length(idx);

if n < 6 | m ~= 9
   error('recons_3views: x must be a 9-by-n matrix, with n >= 6');
elseif len < 6
   error('recons_3views: idx must be of length at least 6');
end

for i=1:3
   xi(:,:,i) = x((i-1)*3+1:i*3,:);
end

% Step (i): randomly select four triplets from the index list, idx,
% to form the basis e1, e2, e3, e4
tmp = randperm(len);
can_idx = idx(tmp(1:4));  % indices of points that will be mapped to canonical form
can_idxbar = idx(tmp(5:len));  % the other indices
% we may need to do some checking here to ensure that no three
% of the points chosen are collinear...

% Step (ii): compute the homography required and transform
% the points accordingly
for i=1:3
   H(:,:,i) = reduced_homography(xi(:,can_idx,i)); 
   xhat(:,:,i) = H(:,:,i)*xi(:,:,i);
end

% Steps (iii) and (iv): solve for the dual fundamental matrix.
xhat_ = xhat(:,can_idxbar,:);
Fd_ = dual_fundmatrix(squeeze(xhat_(:,1,:)), squeeze(xhat_(:,2,:)));

% the first five world points for the dual problem must be...
X5 = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1; 1 1 1 1]';
PP = [];
for soln=1:length(Fd_)
   % Step (vi): solve for the parameters a, b, c, and d for projection
   % matrix P2
   Fd = Fd_{soln};
   abc = lsq([0 Fd(2,3) Fd(3,2); Fd(1,3) 0 Fd(3,1); Fd(1,2) Fd(2,1) 0]);
   dabc = lsq(Fd');
   A = [skew(abc) zeros(3,1);
      skew(dabc) [dabc(2)-dabc(3); dabc(3)-dabc(1); dabc(1)-dabc(2)]
   ];
   vec = lsq(A);
   % the sixth world point is vec=[a b c d]'
   Xi = [X5 vec];
   % use these 6 world and image points to compute the 3 projection
   % matrices (via DLT)
   for view=1:3
      PP(:,:,view) = projmatrix_DLT(Xi, xi(:,[can_idx can_idxbar],view)); 
   end
   
   % now use the estimated projection matrix to reconstruct more world points
   % via triangulation
   X{soln} = triangulate(PP,x);   
   P{soln} = PP;
end

if nargout > 1
   varargout{1} = P;
end

if nargout > 2
   for soln=1:length(Fd_)
      errs{soln} = 0;
      Pi = P{soln};
      for view=1:3
         diff = pflat(Pi(:,:,view)*X{soln}) - pflat(xi(:,:,view));
         errs{soln} = errs{soln} + sum(diff.^2,1);
      end
   end 
   varargout{2} = errs;
end

if nargout > 3
   for soln=1:length(Fd_)
      avgerr{soln} = mean(errs{soln});
   end
   varargout{3} = avgerr;
end

return

