function draw_2d_line(abc, box, fig, linestyle)

%DRAW_2D_LINE draws 2D lines onto a specified figure.
%
%   draw_2d_line(abc, box, fig)
%   draw_2d_line(abc, box, fig, linestyle)
%
%   draws a number of 2D lines whose line coordinates are stored in the
%   input argument, abc, to the figure fig.  The second input argument, box,
%   should have the following format:
%      box = [xmin, ymin, xmax, ymax]
%   which contains the two opposite corners of the coordinate axes of the figure.
%
%   Input arguments:
%   - abc must be a 3-by-n matrix of numbers, where each column contains the
%     coefficients a (first row), b (second row), and c (third row) of the line
%     to be drawn (recall that equation of a line has the form: a*x + b*y + c = 0
%   - box must be a array of length 4 as described above.
%   - fig must be an integer indicating the figure number to which drawing should
%     take place.
%   - linestyle (optional argument) must be a string, e.g. 'r-', 'g.-'.  If not
%     specified, then blue solid lines will be drawn.
%
%Created September 2003.
%
%Copyright Du Huynh
%The University of Western Australia
%School of Computer Science and Software Engineering

if nargin < 4
   linestyle = 'b-';
end
xmin = box(1);  ymin = box(2);  xmax = box(3);  ymax = box(4);
[x,y] = meshgrid([xmin xmax], [ymin ymax]);
xvec = reshape(x, size(x,1)*size(x,2), 1);
yvec = reshape(y, size(y,1)*size(y,2), 1);
onevec = ones(size(x,1)*size(x,2), 1);
lines = [xvec yvec onevec]*abc;

figure(fig), hold on
for i=1:size(abc,2)
   % plot the zero contour line
   contour(x, y, reshape(lines(:,i), size(x,1), size(x,2)), [0 0], linestyle);
end

return
