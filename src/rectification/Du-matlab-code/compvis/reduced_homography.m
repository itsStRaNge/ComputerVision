function H = reduced_homography(x)

%REDUCED_HOMOGRAPHY returns the homography that maps 4 given points to canonical form.
%
%   H = reduced_homography(x)
% 
%   Returns the homography, H, between 4 given points to canonical form.  That is,
%   - the first point is mapped to [1 0 0]'
%   - the second point to          [0 1 0]'
%   - the third point to           [0 0 1]'
%   - the fourth point to          [1 1 1]'
%   This linear transformation is more specific than the general homographic
%   transformation and must be computed differently (c.f. homography.m).
%
%   Input arguments:
%   - x must be a 3-by-4 matrix, where each column of the matrix storess one
%     point in homogeneous coordinates.
%
%   Output arguments:
%   - H would be the estimated 3-by-3 homography matrix.
%     
%Created January 2004 by Du Huynh.
%
%Copyright Du Huynh
%The University of Western Australia
%School of Computer Science and Software Engineering

if any(size(x) ~= [3,4])
   error('reduced_homography: x should be a 3-by-4 matrix');
end

h1 = cross(x(:,2), x(:,3)); % first row of H defined up to an unknown scale
h2 = cross(x(:,3), x(:,1)); % second row "  "     "           "       "
h3 = cross(x(:,1), x(:,2)); % third row  "  "     "           "       "

% compute these unknown scales using the 4th point
A = [
   0               dot(h2,x(:,4))  -dot(h3,x(:,4));
   -dot(h1,x(:,4)) 0               dot(h3,x(:,4)) ;
   dot(h1,x(:,4))  -dot(h2,x(:,4)) 0
];
alphas = lsq(A);
H = [alphas(1)*h1'; alphas(2)*h2'; alphas(3)*h3'];
H = H / norm(H,2);

return

