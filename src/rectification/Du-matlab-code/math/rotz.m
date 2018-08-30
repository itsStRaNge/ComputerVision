% function rz = rotz(theta)
%   return the 3x3 rotation matrix that represents the rotation about the z-axis for
%   the specified angle (assumed in deg)
%
%Created Sun, 07/12/97
%Revised Tue, 25/05/99
%
%Copyright Du Huynh
%The University of Western Australia
%School of Computer Science and Software Engineering

function rz = rotz(theta)
	theta = theta*pi/180;
	rz = [cos(theta) -sin(theta) 0;
	      sin(theta) cos(theta)  0;
              0         0       1];
return
