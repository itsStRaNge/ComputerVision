function [F21,varargout] = fundmatrix_from_trifocal(T, e2, e3)

%FUNDMATRIX_FROM_TRIFOCAL computes the epipoles in the 2nd and 3rd images from the trifocal tensor.
%
%   F21 = fundmatrix_from_trifocal(T)
%   [F21, F31] = fundmatrix_from_trifocal(T, e2, e3)
%
%   The function computes the fundamental matrix F21 (and F31, if required) from
%   the input trifocal tensor T.
%
%   Input argument:
%   - T must be a 3-by-3-by-3 matrix containing the trifocal tensor.  The tensor
%     should follow that as described in [1].  i.e. T(j,k,i) with i, j, k being
%     the point indices for the first, second, and third images respectively.
%   - e2 and e3: both are optional arguments.  If provided, both must
%     be 3-by-1 vectors that contain the epipoles in the second and
%     third images corresponding to the first camera centre.
%
%   Output arguments:
%   - Fundamental matrix F21 would be a rank-2 3-by-3 matrix, satisfying the
%     constraint: [x2,y2,z2]*F21*[x1;y1;z1] = 0
%   - Fundamental matrix F31 would be a rank-2 3-by-3 matrix also, satisfying
%     [x2,y3,z3]*F21*[x1;y1;z1] = 0
%
%   Reference:
%   [1] R. Hartley and A. Zisserman, "Multiple View Geometry
%       in Computer Vision", Cambridge University Press 2000,
%       Algorithm 14.1, page 366.
%
%January 20 2004 written by Du Huynh.
%
%Copyright Du Huynh
%The University of Western Australia
%School of Computer Science and Software Engineering

% check input arguments
if any(size(T)~=[3,3,3])
   error('fundmatrix_from_trifocal: T must be 3-by-3-by-3');
end

if nargin < 3
   % e2 and e3 are not given. Compute them.
   [e2,e3] = epipoles_from_trifocal(T);
end

for col=1:3
   F21(:,col) = skew(e2)*T(:,:,col)*e3;
end

if nargout > 1
   for col=1:3
      F31(:,col) = skew(e3)*T(:,:,col)'*e2;
   end
   varargout{1} = F31;
end

return


