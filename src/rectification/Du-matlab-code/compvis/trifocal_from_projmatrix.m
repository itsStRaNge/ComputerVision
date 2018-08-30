function T = trifocal_from_projmatrix(P)

%TRIFOCAL_FROM_PROJMATRIX computes trifocal tensor from the projection matrices.
%
%   T = trifocal_from_projmatrix(P)
%
%   Input argument:
%   - P should be a 3-by-4-by-3 matrix, where P(:,:,i) containing the estimated
%     projection matrix of the i-th camera.  Note that P(:,:,1) should be of
%     the form [I 0].
%
%   Output arguments:
%   - T would be the 3-by-3-by-3 matrix containing the trifocal tensor.
%     The computed tensor follows that as described in [1].  i.e. T(j,k,i)
%     with i, j, k being the point indices for the first, second, and third
%     images respectively.
%
%   Reference:
%   [1] R. Hartley and A. Zisserman, "Multiple View Geometry
%       in Computer Vision", Cambridge University Press 2000,
%       Table 14.2, page 369.
%
%March 10 2004.
%
%Copyright Du Huynh
%The University of Western Australia
%School of Computer Science and Software Engineering

% check input arguments
if size(P,1) ~= 3 | size(P,2) ~= 4
   error('trifocal_from_projmatrix: P should be a 3-by-4-by-3 matrix');
end

if any(any(P(:,:,1) ~= [eye(3) zeros(3,1)]))
   error('trifocal_from_projmatrix: P(:,:,1) should be [I 0]');
end

T = zeros(3,3,3);

for i=1:3 
   for k=1:3
      T(:,k,i) = P(:,i,2)*P(k,4,3) - P(:,4,2)*P(k,i,3);
   end
end
