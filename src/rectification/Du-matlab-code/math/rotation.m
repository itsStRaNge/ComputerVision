% function R = rotation(thetax, thetay, thetaz)
%   return the 3x3 rotation matrix for the specified rotation angles (assumed
%   in deg) about the principal axes.
%
%Created Sun, 03/11/97
%Revised Tue, 25/05/99
%
%Copyright Du Huynh
%The University of Western Australia
%School of Computer Science and Software Engineering

function R = rotation(thetax, thetay, thetaz)
	rx = rotx(thetax);
	ry = roty(thetay);
	rz = rotz(thetaz);
	R = rz * ry * rx;
return
