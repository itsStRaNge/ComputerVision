function [P,errs,avgerr] = projmatrix_DLT(X, x, idx)

%PROJMATRIX_DLT computes the projection matrix from known world and image points using DLT.
%
%   P = projmatrix_DLT(X, x)
%   [P, errs, avgerr] = projmatrix_DLT(X, x, idx)
%
%   The function computes the projection matrix from at least 6 known world
%   and image points using the Direct Linear Transformation (DLT).  For the
%   algorithm to work, the world points must not be coplanar in space.
%
%   Input arguments:
%   - X must be a 4-by-n matrix where each column contains a world point
%     in projective or homogeneous coordinates.  Here, n >= 6.
%   - x must be a 3-by-n matrix where each column contains the corresponding
%     image point in projective or homogeneous coordinates.
%   - idx (optional argument) must be an integer array of a minimum length
%     of 6.  This argument allows samples of 6 correspondences to be selected
%     for estimating P and X in a RANSAC fashion.  If idx is not given
%     then all the world and image points would be used for computing P.
%
%   Output arguments:
%   - P would be a 3-by-4 matrix, containing the estimated projection
%     matrix.
%   - errs (optional argument) would be an array of squared reprojection errors.
%     The i-th element of the array is defined as
%      (xhat(1,i)/xhat(3,i) - x(i,i)/x(3,i))^2 +
%      (xhat(2,i)/xhat(3,i) - x(2,i)/x(3,i))^2
%     where xhat(:,i) = P*X(:,i) is the i-th reprojected image point.
%   - avgerr (optional argument) would contain the average value of
%     elements in the argument errs.
%
%January 20 2004 written by Du Huynh.
%
%Copyright Du Huynh
%The University of Western Australia
%School of Computer Science and Software Engineering

% check input arguments
n = size(X,2);
if nargin < 3 | isempty(idx)
   idx = 1:n;
end
len = length(idx);

if size(X,1) ~= 4 | n < 6
   error('projmatrix_DLT: X must be a 4-by-n matrix, with n >= 6');
elseif size(x,1) ~= 3 | size(x,2) ~= n
   error('projmatrix_DLT: x must have the same number of columns as X');
elseif len < 6
   error('projmatrix_DLT: idx must be an array of length 6');
end

xi = x(:,idx);
Xi = X(:,idx);
% normalization
[Xi,T_world] = normalise(Xi, sqrt(3));
[xi,T_image] = normalise(xi, sqrt(2));

A = [];
A(1:len,:)       = [zeros(len,4) -(xi(3,:)'*ones(1,4)).*Xi' (xi(2,:)'*ones(1,4)).*Xi'];
A(len+1:2*len,:) = [(xi(3,:)'*ones(1,4)).*Xi' zeros(len,4) -(xi(1,:)'*ones(1,4)).*Xi'];
A(2*len+1:3*len,:)=[-(xi(2,:)'*ones(1,4)).*Xi' (xi(1,:)'*ones(1,4)).*Xi' zeros(len,4)];

Pvec = lsq(A);
P = reshape(Pvec,4,3)';

% the normalisation transforms the estimated P as follows
P = inv(T_image)*P*T_world;

if nargout > 1
   % compute the squared reprojection errors of all points
   xhat = P*X;
   errs = (xhat(1,:)./xhat(3,:) - x(1,:)./x(3,:)).^2 + ...
      (xhat(2,:)./xhat(3,:) - x(2,:)./x(3,:)).^2;
end
if nargout > 2
   avgerr = mean(errs);
end

return

