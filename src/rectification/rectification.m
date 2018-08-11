function [T1, T2, Pn1, Pn2] = rectification(Po1, Po2)
% RECTIFICATION source
% https://www.researchgate.net/publication/2841773_Tutorial_on_Rectification_of_Stereo_Images

% focal length
au = norm(cross(Po1(1,1:3)', Po1(3,1:3)'));
av = norm(cross(Po1(2,1:3)', Po1(3,1:3)'));

% potical centers
c1 = - inv(Po1(:, 1:3)) * Po1(:,4);
c2 = - inv(Po2(:, 1:3)) * Po2(:,4); 

% retinal planes
fl = Po1(3, 1:3);
fr = Po2(3, 1:3);

nn = cross(fl, fr);

% solve the four system
A = [[c1' 1]' [c2' 1]' [nn 0]' ]';
[U, S, V] = svd(A);
r = 1/(norm(V([1 2 3], 4)));
a3 = r * V(:, 4);

A = [[c1' 1]' [c2' 1]' [a3(1:3)' 0]' ]';
[U, S, V] = svd(A);
r = norm(av)/(norm(V([1 2 3], 4)));
a2 = r * V(:, 4);

A = [[c1' 1]' [a2(1:3)' 0]' [a3(1:3)' 0]' ]';
[U, S, V] = svd(A);
r = norm(au)/(norm(V([1 2 3], 4)));
a1 = r * V(:, 4);

A = [[c2' 1]' [a2(1:3)' 1]' [a3(1:3)' 0]' ]';
[U, S, V] = svd(A);
r = norm(au)/(norm(V([1 2 3], 4)));
b1 = r * V(:, 4);

% adjustment
H = eye(3,3);

% rectifying projection matrices
Pn1 = H * [a1 a2 a3]';
Pn2 = H * [b1 a2 a3]';

% rectifying image transformation
T1 = Pn1(1:3, 1:3) / Po1(1:3, 1:3);
T2 = Pn2(1:3, 1:3) / Po2(1:3, 1:3);
end

