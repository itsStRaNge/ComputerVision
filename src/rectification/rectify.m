function [T1,T2,Pn1,Pn2] = rectify(K, R, Po1,Po2)
% RECTIFY: compute rectification matrices
% from: https://stackoverflow.com/questions/25745809/image-rectification-algorithm-in-matlab

%% optical centers (unchanged)
c1 = - inv(Po1(:,1:3))*Po1(:,4);
c2 = - inv(Po2(:,1:3))*Po2(:,4);

%% new x axis (= direction of the baseline)
 v1 = (c1-c2);
%% new y axes (orthogonal to new x and old z)
v2 = cross(R(3,:)',v1);
%% new z axes (orthogonal to baseline and y)
v3 = cross(v1,v2);

%% new extrinsic parameters 
R = [v1'/norm(v1)
   v2'/norm(v2)
   v3'/norm(v3)];
%% translation is left unchanged

%% new intrinsic parameters (arbitrary) 
A = K;
A(1,2)=0; % no skew
A(1,3) = A(1,3) + 160;
%% new projection matrices
Pn1 = A * [R -R*c1 ];
Pn2 = A * [R -R*c2 ];

%% rectifying image transformation
T1 = Pn1(1:3,1:3) / Po1(1:3,1:3);
T2 = Pn2(1:3,1:3) / Po2(1:3,1:3);
end

