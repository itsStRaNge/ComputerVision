function [x3_hat,x1_hat,x2_hat] = trifocal_pt_transfer(T, x1, x2, e2, e3, F21)

%TRIFOCAL_PT_TRANSFER computes the point transfer using the trifocal tensor.
%
%   x3_hat = trifocal_pt_transfer(T, x1, x2)
%   [x3_hat, x1_hat, x2_hat] = trifocal_pt_transfer(T, x1, x2, e2, e3, F21)
%
%   The function computes the point x3 transferred from a list of
%   correspondences x1 <-> x2 using the given trifocal tensor T.
%
%   Input arguments:
%   - T must be a 3-by-3-by-3 matrix containing the trifocal tensor.  The tensor
%     should follow that as described in [1].  i.e. T(j,k,i) with i, j, k being
%     the point indices for the first, second, and third images respectively.
%   - x1 and x2: must both be either 3-by-n matrices.
%     Here, n is the number of correspondences to be transferred.
%   - e2 and e3: both are optional arguments.  If provided, both must
%     be 3-by-1 vectors that contain the epipoles in the second and
%     third images corresponding to the first camera centre.
%
%   Output arguments:
%   - x3_hat is the list of transferred points, the dimensions of which
%     are 3-by-n.   
%   - x1_hat and x2_hat are both optional arguments.  If specified,
%     they would contain the list of correspondences as x1 and x2
%     but whose coordinates have been corrected.
%
%   Functions required: correct_match_pts
%
%   Reference: 
%   [1] R. Hartley and A. Zisserman, "Multiple View Geometry
%       in Computer Vision", Cambridge University Press 2000,
%       page 373.
%
%January 19 2004 written by Du Huynh.
%
%Copyright Du Huynh
%The University of Western Australia
%School of Computer Science and Software Engineering

% check input arguments
if ~isempty(find(size(x1)~=size(x2)))
   error('trifocal_pt_transfer: x1 and x2 must both be of the same size');
elseif size(x1,1) ~= 3
   error('trifocal_pt_transfer: x1 and x2 must be 3-by-n matrices');
end

% Step(i): compute F21 if necessary and the improved correspondences
%          x1hat <-> x2hat
if nargin < 5
   [e2, e3] = epipoles_from_trifocal(T);
end
if nargin < 6
   % need to compute the fundamental matrix F21 as it is not provided.
   for col=1:3
      F21(:,col) = skew(e2)*T(:,:,col)*e3;
   end
end

[x1hat,x2hat] = correct_match_pts(x1, x2, F21);

% Step(ii): compute the line l2 through x2hat and perpendicular to le2 = F21*x1hat
le2 = F21*x1hat;
l2 = [le2(2,:).*x2hat(3,:); -le2(1,:).*x2hat(3,:); -x2hat(1,:).*le2(2,:)+x2hat(2,:).*le2(1,:)];

% Step(iii): compute the transferred point
n = size(x1,2);
for pt=1:n
   x3_hat(:,pt) = (T(:,:,1)*x1hat(1,pt) + T(:,:,2)*x1hat(2,pt) + T(:,:,3)*x1hat(3,pt))'*l2(:,pt);
end

if nargout > 1, x1_hat = x1hat; end
if nargout > 2, x2_hat = x2hat; end

return

