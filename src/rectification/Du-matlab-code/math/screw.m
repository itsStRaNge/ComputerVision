function [v,theta] = screw(R)

%screw returns the axis and angle of rotation of a given rotation matrix.
%
%[v,theta] = screw(R)
%v = theta(R)
%  returns the axis of rotation, v, and angle of rotation, theta, such
%  that theta is in the range [0,pi].
%
%Input parameter:
%  R must be a 3-by-3 rotation matrix.
%
%Output parameters:
%  v     would be the unit (column) vector that represents the axis of
%        rotation, if the second output parameter, theta, is also used.
%        Otherwise, the angle theta would be absorbed into v as a scale
%        factor and v will not be a unit vector.
%  theta, if used, would be the angle of rotation in radians.
%
%Du Huynh, September 2007 (modified in September 2008)
%School of Computer Science and Software Engineering
%The University of Western Australia

%Note that Rodrigues' formula is given by
%  R = cos(theta)*I + sin(theta)*skew(v) + (1-cos(theta))*v*v'  (1)
%Thus, R' = rotation(v,-theta) is
%  R'= cos(theta)*I - sin(theta)*skew(v) + (1-cos(theta))*v*v'  (2)
%(1)-(2) gives
%  R-R' = 2*sin(theta)*skew(v)

ang = real(acos((trace(R)-1)/2));  % note round-off error can make acos
                                   % return a complex number with a small
                                   % imaginary value
M = R-R';
v = [-M(2,3); M(1,3); -M(1,2)];
% acos always returns the angle in [0,pi] - in this range of angles,
% sine > 0 always! so the angle returned by acos would go with our
% choice of the vector v computed above.  We assume that sin(theta) > 0

% Although it seems that -theta could be the correct answer, the choice
% of our computed v above completely rules this out.

if abs(ang) < 1e-8
   % R is an identity matrix
   v = [1;0;0];
elseif abs(ang-pi) < 1e-6
   % each column of R+I is a scaled version of v
   RI = R+eye(3);
   RI = RI ./ repmat(sqrt(sum(RI.^2,1)),3,1); % normalise each column of RI
   v = mean(abs(RI),2).*sign(RI(:,1));
else
   if norm(v,2) < 1e-15
      error('oop... v is a zero vector?');
   else
      v = v/norm(v,2);
   end
end

if nargout == 2
   theta = ang;
else
   v = v*ang;
end

return
   