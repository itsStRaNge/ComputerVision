function X = triangulate(P, x)

%TRIANGULATE computes world points via the direct linear transformation (DLT).
%
%   X = triangulate(P, x)
%
%   The function computes the structures, X, using the list of
%   correspondences stored in the argument x. 
%
%   Input arguments:
%   - P must be a 3-by-4-by-m matrix where P(:,:,i) stores the projection
%     matrix for the i-th camera view.
%   - x must be a 3m-by-n matrix where each column contains a correspondence
%     in m images being stacked together.  That is, each column
%     has the form (x1,y1,z1,x2,y2,z2,...xm,ym,zm)', denoting the match
%     (x1,y1,z1) <-> (x2,y2,z2) <-> ... <-> (xm,ym,zm).
%
%   Output arguments:
%   - X would be 4-by-n matrix, where each column stores a reconstructed
%     world point.
%
%   *** As a linear method is used here, if there are errors in the image
%       coordinates then the estimated world point X would not be optimal.
%       A correction procedure should therefore be applied to the image
%       coordinates before calling this function.  For instance, if there
%       are only two camera views then correct_match_pts could be used.
%
%   SEE ALSO correct_match_pts, recons_2views
%
%January 23 2004 written by Du Huynh.
%
%Copyright Du Huynh
%The University of Western Australia
%School of Computer Science and Software Engineering

[d,n] = size(x);
m = d / 3;
% check input arguments
if ~isposint(m) | m < 2
   error('triangulate: x must be d-by-n, where d = 3*m with m >= 2');
elseif size(P,1) ~= 3 | size(P,2) ~= 4 | size(P,3) ~= m
   error('triangulate: wrong dimensions for matrix P');
end

X = [];
for pt=1:n
   A = [diag(x(3:3:d,pt))*squeeze(P(1,:,:))' - diag(x(1:3:d,pt))*squeeze(P(3,:,:))';
      diag(x(3:3:d,pt))*squeeze(P(2,:,:))' - diag(x(2:3:d,pt))*squeeze(P(3,:,:))'
   ];
   X(:,pt) = lsq(A);
end

return