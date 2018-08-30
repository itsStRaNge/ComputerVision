% function ry = roty(theta)
%   return the 3x3 rotation matrix that represents the rotation about the y-axis for
%   the specified angle (assumed in deg)
%
%Created Sun 17/07/97
%Revised Tue 25/05/99
%
%Copyright Du Huynh
%The University of Western Australia
%School of Computer Science and Software Engineering

function ry = roty(theta)
	theta = theta*pi/180;
	ry = [cos(theta) 0 sin(theta);
	          0      1      0;
         -sin(theta) 0 cos(theta)];
return
