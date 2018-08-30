function [T,varargout] = trifocal_6pts(x, idx)

%TRIFOCAL_6PTS computes the trifocal tensor using the 6 points algorithm.
%
%   T = trifocal_6pts(x)
%   [T, errs, avgerr] = trifocal_6pts(x, idx)
%
%   The function computes the trifocal tensor T using the list of
%   corresponding triplets stored in the argument x.  The selection
%   of triplets for computing the tensor can be specified in the
%   second argument, idx.
%
%   Input arguments:
%   - x must be a 9-by-n matrix where each column contains a corresponding
%     triplet in 3 images being stacked together.  That is, each column
%     has the form (x1,y1,z1,x2,y2,z2,x3,y3,z3)', denoting the matching
%     triplet (x1,y1,z1) <-> (x2,y2,z2) <-> (x3,y3,z3).
%     Here, n must be >= 6.
%   - idx (optional argument) must be an integer array of a minimum length
%     of 6.  This argument allows samples of 6 triplets to be selected
%     for estimating T in a RANSAC fashion.
%
%   Output arguments:
%   - T is 3-by-3-by-3 matrix containing the estimtaed trifocal tensor.
%     The notation as described in [1] is adopted here, with the indices
%     i, j, and k in T(i,j,k) denoting the indices for the features in
%     the first, second, and third images respectively.
%   - errs (optional argument) would be an n-array of residual errors
%     for all the triplets stored in the argument x.
%   - avgerr (optional argument) would contain the average value of elements
%     in the argument errs.
%
%   Reference: 
%   [1] R. Hartley and A. Zisserman, "Multiple View Geometry
%       in Computer Vision", Cambridge University Press 2000,
%       Algorithm 19.1, page 493.
%
%January 20 2004 written by Du Huynh.
%
%Copyright Du Huynh
%The University of Western Australia
%School of Computer Science and Software Engineering

% check input arguments
[m,n] = size(x);
if nargin < 2 | isempty(idx)
   idx = 1:6;
end
len = length(idx);

if n < 6 | m ~= 9
   error('trifocal_6pts: x must be a 9-by-n matrix, with n >= 6');
elseif len < 6
   error('trifcal_6pts: idx must be of length at least 6');
end

[X,P,errs,avgerr] = recons_3views(x, idx);

% Note that all the output arguments from recons_3views are cell arrays
% of the same length.  The number of cells in the arrays is the number
% of possible solutions.
for soln=1:length(X)
   PP = P{soln};
   PP = canonical_P(PP);
   for i=1:3
      TT(:,:,i) = PP(:,i,2)*PP(:,4,3)' - PP(:,4,2)*PP(:,i,3)';
   end
   T{soln} = TT;
end

if nargout > 1
   varargout{1} = errs;
end
if nargout > 2
   varargout{2} = avgerr;
end

return

