function [F,varargout] = fundmatrix_wls(xy1xy2, idx, scale)

%FUNDMATRIX_WLS computes the fundamental matrix using the iterative reweighted least squares method.
%
%   F = fundmatrix_wls(xy1xy2, idx)
%   F = fundmatrix_wls(xy1xy2, idx, scale)
%   [F,errs] = fundmatrix_wls(xy1xy2, idx)
%   [F,errs] = fundmatrix_wls(xy1xy2, idx, scale)
%   [F,errs,avgerr] = fundmatrix_wls(xy1xy2, idx)
%   [F,errs,avgerr] = fundmatrix_wls(xy1xy2, idx, scale)
%
%   estimates the fundamental matrix using the iterative reweighted least squares
%   method.  The corresponding point coordinates should be stored in the large
%   6-by-n matrix of the following format:
%      xy1xy2 = [x1_1  x1_2 ... x1_n;
%                y1_1  y1_2 ... y1_n;
%                z1_1  z1_2 ... z1_n;
%                x2_1  x2_2 ... x2_n;
%                y2_1  y2_2 ... y2_n;
%                z2_1  z2_2 ... z2_n ]
%   where [x1_i, y1_i, z1_i] in the first three rows is the i-th feature point
%                            (in homogeneous coordinates) in the first image;
%         [x2_i, y2_i, z2_i] in the last three rows is the i-th feature point
%                            (in homogeneous coordinates) in the second image;
%         each column of the matrix stores a pair of corresponding points in
%         homogeneous coordinates.
%
%   The fundmental matrix, F, is a rank-2 3-by-3 matrix satisfying the epipolar
%   constraint:
%                            (x1_i)
%     (x2_i y2_i z2_i) * F * (y1_i) = 0
%                            (z1_i)
%
%   Input arguments:
%   - xy1xy2 should be a 6-by-n matrix where n >= 8.  It is recommended that
%     the coordinates of points in this matrix be relative to an image coordinate
%     system whose origin is at the centre (or principal point, if known) of
%     the image.
%   - idx must be an array of integers in the range [1,n] where n=size(xy1xy2,2).
%     Alternatively, set idx=[] if all the points in xy1xy2 are intended to be
%     used for the estimation of F.
%   - scale (optional) is the scale factor to be used in least squares to keep
%     things well behaved.  If not specified, a scale factor would be automatically
%     computed (Referencee: see Hartley's ICCV'95 paper).  If specified, a sensible
%     scale factor is half of the average of the image dimensions, eg. if the images
%     are of dimensions 400-by-600 then scale should be set to 500/2 = 250.
%
%   Output arguments:
%   - F is the rank-2 3-by-3 fundamental matrix.
%   - errs is the list of reprojection errors (orthogonal distance errors of
%     the feature points from the epipolar lines) of all the feature point in xy1xy2.
%   - avgerr is the average squared reprojection error, i.e. the mean value of errs.
%
%Created 1996.
%Revised September 2003.
%
%Copyright Du Huynh
%The University of Western Australia
%School of Computer Science and Software Engineering

% The weighing factor for each pair of corresponding points is initialized
% to unity.  These factors are all set to unity initially.

% Call fundmatrix_ls to get an initial estimate of the fundamental matrix
if nargin == 2
   scale = 1;
end

[F,errs,avgerr] = fundmatrix_ls(xy1xy2, idx, scale);

% compute the residual, res, (not used, actually) and gradient of residual
[res,grad_res] = fundmatrix_res(F, xy1xy2);

% the weighting factor each each pair of corresponding points is the
% inverse of the residual gradient.  I put in an extra sqrt in the formula
% for ws below because ws is going to multiply matrix A in fundmatrix_ls
% and then the solution is found by calling svd of A'*A.  
ws = 1 ./ sqrt(sqrt(grad_res));

% Empirically, I found that 20 iterations are more than sufficient.
if isempty(idx)
   siz = size(xy1xy2,2);
else
   siz = length(varargin{2});
end

ii=2;
for i=1:20
   [F,errs,avgerr] = fundmatrix_ls(xy1xy2, idx, ws, scale);
   [res,grad_res] = fundmatrix_res(F, xy1xy2);
   ws = 1 ./ sqrt(sqrt(grad_res));
end

% call fundmatrix_ls one more time to get output for varargout
[F,varargout{1},varargout{2}]= fundmatrix_ls(xy1xy2, ws, varargin{:});

return


% ------------------------------------------------------------------------

function [res,grad_res] = fundmatrix_res(F, xy1xy2)

xy1 = xy1xy2(1:3,:);
xy2 = xy1xy2(4:6,:);
res = sum(xy2' .* (F*xy1)', 2);

if nargout > 1
   grad_res = sqrt(...
      (xy2' * F(:,1)).^2 + ...    % partial derivative of res wrt x
      (xy2' * F(:,2)).^2 + ...    % partial derivative of res wrt y
      (F(1,:) * xy1)'.^2  + ...    % partial derivative of res wrt x'
      (F(2,:) * xy2)'.^2);         % partial derivative of res wrt y;
end
return


