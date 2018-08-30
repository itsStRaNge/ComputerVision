% function rx = rotx(theta)
%   return the 3x3 rotation matrix that represents the rotation of
%   the specified angle (assumed in deg) about the x-axis.
%
%Created Sun 07/12/97
%Revised Tue 25/05/99
%
%Copyright Du Huynh
%The University of Western Australia
%School of Computer Science and Software Engineering

function rx = rotx(theta)
	theta = theta*pi/180;
	rx = [1      0          0;
	      0 cos(theta) -sin(theta);
         0 sin(theta) cos(theta)];
return
