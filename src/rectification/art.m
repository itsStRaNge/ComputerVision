function [A,R,t] = art(P)
% ART: factorize a PPM as  P=A*[R;t]
Q = inv(P(1:3, 1:3));
[U,B] = qr(Q);
R = inv(U);
t = B*P(1:3,4);
A = inv(B);
A = A ./A(3,3);
end