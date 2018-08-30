function q = qcreate(w,a)

%qcreate creates a quaternion from a screw axis w and screw angle a.
%
%q = qcreate(w,a)
%
%Input parameters:
%  w should be a 3-vector (column) of unit magnitude representing the
%    rotation axis.
%  a should be the rotation angle.
%
%Output parameter:
%  q would be a unit quaternion (as a column vector) representing
%    the given rotation.
%
%Du Huynh, September 2007.
%School of Computer Science and Software Engineering
%The University of Western Australia

q = [cos(0.5*a); sin(0.5*a)*w];
q = q/norm(q,2);

return