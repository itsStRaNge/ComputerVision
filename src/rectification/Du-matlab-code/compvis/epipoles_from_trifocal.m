function [e2,e3] = epipoles_from_trifocal(T)

%EPIPOLES_FROM_TRIFOCAL computes the epipoles in the 2nd and 3rd images from the trifocal tensor.
%
%   [e2, e3] = epipoles_from_trifocal(T)
%
%   The function computes the epipoles in the second and third images
%   corresponding to the first camera centre.
%
%   Input argument:
%   - T must be a 3-by-3-by-3 matrix containing the trifocal tensor.  The tensor
%     should follow that as described in [1].  i.e. T(j,k,i) with i, j, k being
%     the point indices for the first, second, and third images respectively.
%
%   Output arguments:
%   - e2 would be a 3-vector, containing the epipole in the second image.
%   - e3 would be a 3-vector, containing the epipole in the third image.
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
   error('epipoles_from_trifocal: T must be 3-by-3-by-3');
end

U = zeros(3,3);  U = zeros(3,3);
for i=1:3
   U(:,i) = null(T(:,:,i)');
   V(:,i) = null(T(:,:,i));
end
e2 = null(U');
e3 = null(V');
return
