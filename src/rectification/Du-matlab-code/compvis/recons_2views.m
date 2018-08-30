function [X, varargout] = recons_2views(x, F)

%RECONS_2views computes the projective structures from 2 views.
%
%   X = recons_2views(x, F)
%   [X, P, errs, avgerr] = recons_2views(x, F)
%
%   The function computes the projective structures using the given list of
%   correspondences stored in the argument x and the known fundamental matrix.
%
%   Input arguments:
%   - x must be a 6-by-n matrix where each column contains a correspondence
%     in 2 images being stacked together.  That is, each column has the
%     form (x1,y1,z1,x2,y2,z2)', denoting the matching point
%     (x1,y1,z1) <-> (x2,y2,z2).
%   - F, the fundamental matrix, must be a 3-by-3 rank-2 matrix.
%
%   Output arguments:
%   - X would be a 4-by-n matrix containing the projective coordinates
%     of the reconstructed 3D points.
%   - P (optional argument) would be a 3-by-4-by-2 matrix, where P(:,:,i)
%     stores the the estimted projection matrix for the i-th camera view.
%   - errs (optional argument) would be an array containing the squared
%     reprojection errors of reconstruction.
%   - avgerr (optional argument) would contain the average squared
%     reprojection errors.
%
%   *** NOTE: There are two random entities involved in determining
%       the projection matrix P(:,:,2).  Thus, a different X (and P)
%       matrix would be generated each time the function is called.
%
%   AUXILIARY FUNCTIONS REQUIRED: correct_match_pts, triangulate
%
%   Reference:
%   [1] R. Hartley and A. Zisserman, "Multiple View Geometry
%       in Computer Vision", Cambridge University Press 2000,
%       Algorithm 11.1, page 304.
%
%January 20 2004 written by Du Huynh.
%
%Copyright Du Huynh
%The University of Western Australia
%School of Computer Science and Software Engineering

% check input arguments
if size(x,1) ~= 6
   error('recons_2views: x must be a 6-by-n matrix');
end

x1 = x(1:3,:);
x2 = x(4:6,:);

% Call correct_match_pts to carry out Steps (i)-(x) of
% the algorithm.
[x1hat,x2hat] = correct_match_pts(x1, x2, F);

% Step (xi)
e2 = lsq(F');        % epipole of first camera centre in the second image
% v is an arbitrary vector and lambda is an arbitrary scalar
v = randn(3,1);
lambda = randn(1,1);
if abs(lambda) < 0.1, lambda = lambda+1; end
P = [];
P(:,:,1) = [eye(3) zeros(3,1)];
P(:,:,2) = [skew(e2)*F+e2*v' lambda*e2];

X = triangulate(P, [x1hat; x2hat]);

if nargout > 1
   varargout{1} = P;
end
if nargout > 2
   diff1 = pflat(P(:,:,1)*X) - pflat(x1);
   diff2 = pflat(P(:,:,2)*X) - pflat(x2);
   errs = sum(diff1.^2 + diff2.^2, 1);
   varargout{2} = errs;
end
if nargout > 3
   varargout{3} = mean(errs);
end

return
