function [xnorm,T,varargout] = normalise(x, rmsdist, orig)

%NORMALISE normalises a list of points for subsequent numerical computation.
%
%   [xnorm,T] = normalise(x, rmsdist)
%   [xnrom,T,T1,T2] = normalise(x, rmsdist, orig)
%
%   The function normalises the list of points stored in argument x
%   and returns the normalised points to xnorm.  Details of the
%   normalisation are given below:
%   Step 1: translation
%       If the third input argument, orig, is specified, then the
%       all the points stored in x are first translated so that the
%       origin is at orig.  If the third input argument, orig, is not
%       specified, then all the points stored in x would be translated
%       so that the origin is at the centroid of the point cluster.
%   Step 2: scaling
%       A scaling operation is then performed so that the root-mean-squared
%       distance of the points in x is equal to rmsdist.
%
%   Input arguments:
%   - x must be a d-by-n matrix where each column stores one point.
%     The value of d is often much smaller than the value of n.  For
%     image points, d = 3; for world points, d = 4.
%     *** Note that the data stored in matrix x must be in homogeneous
%         coordinates with the last component of each point set to 1 before
%         calling this function.
%   - rmsdist should be a double floating point number.
%   - orig (optional argument) should be an array of length d.
%                                                                  
%   Output arguments:
%   - xnorm would be the matrix containing the normalised point coordinates.
%   - T would be the transformation matrix satisfying T*x = xnorm.
%   - T1 and T2 are both optional arguments.  If specified, T1 would
%     contain the transformation for the translation (Step 1) and T2 would
%     be the scaling matrix (for Step 2).  The last three output arguments
%     satisfy: T = T2*T1.
%
%   References:
%   [1] R. I.  Hartley, "In Defence of the 8 Points Algorithm", ICCV 1995.
% 
%Du Huynh, created December 1998.
%Du Huynh, modified October 2000.

% check arguments
[d,n] = size(x);
if nargin > 2
   if ndims(orig) ~= 2 | ~any(size(orig)==1) | length(orig) ~= d
      error('normalise: orig has the wrong dimensions');
   end
elseif d ~= 3 & d ~= 4
   error('normalise: x must be a d-by-n matrix where d=3 or 4');
end

T1 = eye(d);                                      
if nargin <= 2
   % compute the centroid of the point cluster
   centroid = mean(x,2);
   T1(1:d-1,d) = -centroid(1:d-1);
else
   T1(1:d-1,d) = -orig(1:d-1);
end

x = T1*x;

% work out the scale factor required
scale = rmsdist / sqrt(mean(sum(x(1:d-1,:).^2,1)));

T2 = [scale*eye(d-1) zeros(d-1,1); zeros(1,d-1) 1];

T = T2*T1;
xnorm = T2*x;

if nargout > 2
   varargout{1} = T1;
end
if nargout > 3
   varargout{2} = T2;
end

return
