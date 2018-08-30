function P = projmatrix_from_trifocal(T, e2, e3)

%PROJMATRIX_FROM_TRIFOCAL computes the projection matrices from the trifocal tensor.
%
%   P = projmatrix_from_trifocal(T)
%   P = projmatrix_from_trifocal(T, e2, e3)
%
%   Input arguments:
%   - T must be a 3-by-3-by-3 matrix containing the trifocal tensor.  The tensor
%     should follow that as described in [1].  i.e. T(j,k,i) with i, j, k being
%     the point indices for the first, second, and third images respectively.
%   - e2 and e3 are optional arguments.  If provided, both should be 3-vectors.
%     They should be the epipoles in the second and third images corresponding
%     to the first camera centre.
%
%   Output argument:
%   - P would be a 3-by-4-by-3 matrix, where P(:,:,i) containing the estimated
%     projection matrix of the i-th camera.
%
%   Reference:
%   [1] R. Hartley and A. Zisserman, "Multiple View Geometry
%       in Computer Vision", Cambridge University Press 2000,
%       Algorithm 14.1, page 366.
%
%January 26 2004 written by Du Huynh.
%
%Copyright Du Huynh
%The University of Western Australia
%School of Computer Science and Software Engineering

% check input arguments
if any(size(T)~=[3,3,3])
   error('projmatrix_from_trifocal: T must be 3-by-3-by-3');
end

if nargin < 2
   % the epipoles e2 and e3 are not provided.  Compute them.
   [e2,e3] = epipoles_from_trifocal(T);
end

% first projection matrix
P(:,:,1) = [eye(3) zeros(3,1)];

% second projection matrix
for col=1:3
   P(:,col,2) = T(:,:,col)*e3;
end
P(:,4,2) = e2;

% third projection matrix
tmp = e3*e3' - eye(3);
for col=1:3
   P(:,col,3) = tmp*T(:,:,col)'*e2;
end
P(:,4,3) = e3;

return

