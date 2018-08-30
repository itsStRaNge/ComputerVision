function xnew = qrotate(q, x)

%qrotate rotates a given point by a rotation represented as a quaternion.
%
%xnew = qrotate(q, x)
%
%Input parameters:
%  q should be the quaternion (4-vector (column) of unit magnitude)
%    representing the rotation.
%  x should be a point to be rotated, represented as a 3-vector.
%
%Ouput parameter:
%  xnew would be a 3-vector containing the coordinates of the point
%    after the rotation.
%
%Du Huynh, September 2007.
%School of Computer Science and Software Engineering
%The University of Western Australia

x = [0; x];
xnew = qmult(qmult(q,x),qconj(q));
% the first component should be 0.  No checking is done here though.
xnew = xnew(2:4);
