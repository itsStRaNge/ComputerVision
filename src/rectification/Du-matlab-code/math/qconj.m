function qbar = qconj(q)

%qconj returns the conjugate of a quaternion.
%
%result = qconj(q)
%
%Input parameters:
%  q should be a 4-vector representing the quaternion.
%
%Ouput parameter:
%  qbar would be a quaternion represented as a 4-vector.
%
%Du Huynh, September 2007.
%School of Computer Science and Software Engineering
%The University of Western Australia

qbar = [q(1); -q(2:4)];
