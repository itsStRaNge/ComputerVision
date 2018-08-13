function [JL, JR] = rectify_cheap(IL, PL, IR, PR)
%% compute and apply homography
[HL, HR, ~, ~] = rectify_cheap_algo(PL, PR);

tform = projective2d(HL);
JL = imwarp(IL,tform);

tform = projective2d(HR);
JR = imwarp(IR, tform);
end

function [T1,T2,Pn1,Pn2] = rectify_cheap_algo(Po1,Po2)
% factorize old PPMs
[A1,R1,t1] = art(Po1);
[A2,R2,t2] = art(Po2);

%% optical centers (unchanged)
c1 = - inv(Po1(:,1:3))*Po1(:,4);
c2 = inv(Po2(:,1:3))*Po2(:,4); % original multiply with -1 but then v = 0..

%% new x axis (= direction of the baseline)
 v1 = (c1-c2);
%% new y axes (orthogonal to new x and old z)
v2 = cross(R1(3,:)',v1);
%% new z axes (orthogonal to baseline and y)
v3 = cross(v1,v2);

%% new extrinsic parameters 
R = [v1'/norm(v1)
   v2'/norm(v2)
   v3'/norm(v3)];

%% new intrinsic parameters (arbitrary) 
A = (A1 + A2)./2;
A(1,2)=0; % no skew
A(1,3) = A(1,3) + 160;
%% new projection matrices
Pn1 = A * [R -R*c1 ];
Pn2 = A * [R -R*c2 ];

%% rectifying image transformation
T1 = Pn1(1:3,1:3) / Po1(1:3,1:3);
[U, S, V] = svd(T1);
T1 = U * (S/S(2,2)) * V;
T2 = Pn2(1:3,1:3) / Po2(1:3,1:3);
[U, S, V] = svd(T2);
T2 = U * (S/S(2,2)) * V;
end

function [A,R,t] = art(P)
%% ART: factorize a PPM as  P=A*[R;t]
Q = inv(P(1:3, 1:3));
[U,B] = qr(Q);

R = inv(U);
t = B*P(1:3,4);
A = inv(B);
A = A ./A(3,3);
end

