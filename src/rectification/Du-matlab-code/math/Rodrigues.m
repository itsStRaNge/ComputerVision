function R = Rodrigues(v,theta)

%Rodrigues returns the rotation matrix computed using Rodrique's formula.
%
%R = Rodrigues(v,theta)
%
%Input parameters:
%  v should be 3-vector (as column vector) of unit length if the angle
%    theta is provided.
%  theta is an optional parameter that represents the angle of rotation
%    in radians.  If theta is not provided, then the angle is assumed
%    to be absorbed as a scale factor in vector v, which, need not be
%    a unit vector.
%    Note that if theta is provided yet v is not a unit vector, then
%    an incorrect matrix would be produced.
%
%Note: Rodrigues' formula is given by
%  R = cos(theta)*I + sin(theta)*skew(v) + (1-cos(theta))*v*v'
%
%Du Huynh, September 2007
%School of Computer Science and Software Engineering
%The University of Western Australia

if nargin == 1
   % assume that theta is absorbed in vector v
   theta = norm(v,2);
   v = v/theta;
end

R = cos(theta)*eye(3) + sin(theta)*skew(v) + (1-cos(theta))*v*v';

return
