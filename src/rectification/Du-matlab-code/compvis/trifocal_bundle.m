function [P, X, T, res] = trifocal_bundle(P0, X0, x)

%TRIFOCAL_BUNDLE  bundle adjustment on the projection matrices and projective structures.
%
%   [P, X, T] = trifocal_bundle(P0, X0, x)
%   [P, X, T, res] = trifocal_bundle(P0, X0, x)
%
%   performs bundle adjustment to refine the given set of projection
%   matrices and projective structures.
%
%   Input arguments:
%   - P0 should be a 3-by-4-by-3 matrix where P0(:,:,i) stores the
%     projection matrix for the i-th image. 
%   - X0 should be a 4-by-n matrix where each column of the matrix stores a
%     scene point in projective coordinates.  Here, n should be the number
%     of scene points.
%   - x should be either
%       - a 3-by-n-by-3 matrix where x(:,j,i) stores the coordinates of the j-th
%         image point in the i-th image, or
%       - a 3*3-by-n matrix where each column of the matrix stores the
%         coordinates of the j-th correspondence.
%
%   Output arguments:
%   - P would be a matrix storing the refined projection matrices.  It
%     would have the same dimensions as P0.
%   - X would be a matrix, which has the same dimensions as X0, storing the
%     refined scene point coordinates.
%   - T would be the recomputed 3-by-3-by-3 trifocal tensor.
%   - res is an optional argument.  If used, it would store the residual (a
%     scalar) of the bundle adjustment.
%
%Du Huynh
%School of Computer Science and Software Engineering
%The University of Western Australia

n = size(X0,2);  % number of points
m = 3;           % number of images

% check input arguments
if any(size(P0) ~= [3,4,3])
   error('trifocal_bundle: P0 should be a 3-by-4-by-m matrix');
elseif size(X0,1) ~= 4
   error('trifocal_bundle: X0 should be a 4-by-n matrix');
elseif any(size(x) ~= [3,n,3]) | any(size(x) ~= [9,n])
   error('trifocal_bundle: x should be a 3-by-n-by-3 or 9-by-n matrix');
end

% convert the projection matrices into the form designed by the Lund
% research group:
% [pd,pind] stores the projection matrices
% [xd,xind] stores the image correspondences
[pd0,pind0] = nyml;
for i=1:size(P0,3), [pd0,pind0] = laggtillml(pd0,pind0,P0(:,:,i)); end

if size(x,3) == 1
   % x must be a 3*m-by-n matrix
   [xd0,xind0] = nyml;
   for i=1:m, [xd0,xind0] = laggtillml(xd0,xind0,x((i-1)*3+(1:3),:)); end
else   
   % x should be a 3-by-n-by-m matrix
   [xd0,xind0] = nyml;
   for i=1:m, [xd0,xind0] = laggtillml(xd0,xind0,x(:,:,i)); end
end

[X,pd,pind,fs]=bundle2(xd0,xind0,X0,pd0,pind0);

% convert [pd,pind] back to the 3D array format
P = reshape(pd, 3, 4, 3);

% The P(:,:,1) produced by bundle2 may not be equal to [I 0].  We need
% to convert it back to [I 0]
H = [inv(P(:,1:3,1)) inv(P(:,1:3,1))*P(:,4,1); 0 0 0 1];
for i=1:3
   P(:,:,i) = P(:,:,i)*H;
end

% reconstruct the trifocal tensor
T = trifocal_from_projmatrix(P);

if nargout > 3
   res = fs;
end


