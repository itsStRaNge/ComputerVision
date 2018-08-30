function result = qmult(q1,q2)

%qmult multiples two quaternions and returns their product.
%
%result = qmult(q1,q2)
%
%Input parameters:
%  q1 and a2 should both be 4-vector (column) representation of the quaternions.
%
%Ouput parameter:
%  result would be a quaternion represented as a 4-vector (column).
%
%Du Huynh, September 2007.
%School of Computer Science and Software Engineering
%The University of Western Australia


result = [q1(1)*q2(1) - dot(q1(2:4),q2(2:4));
   q1(1)*q2(2:4) + q2(1)*q1(2:4) + cross(q1(2:4),q2(2:4))
];

   
   
