function [JL, JR, HL, HR] = du_rectification(IL, IR, Corr, plot)
%% adjusted file from http://staffhome.ecm.uwa.edu.au/~00050673/Tutorials/rectification/
xx1 = Corr(1:2,:)';
xx2 = Corr(3:4,:)';

%% use this hack to distinguish between image and empty space later,
%% after rectification has been applied
IL = IL + 1;
IR = IR + 1;

% Notes:
% (1) xx1 and xx2 should both be of size n-by-2 matrices, with one image point per row.
%     Here n is the number of corresponding points and, for the estimation of the
%     fundamental matrix, n >= 7.  In the code for rectification, we follow the
%     convention that each column contains an image point in homogeneous coordinates.
% (2) xx1 and xx2 should be in x-y coordinates, with the origin of the image coordinate
%     system at the top-left corner and y-axis pointing down.  For the computation
%     that follows, we need to convert the image coordinate system to be origined
%     at the centre of the image buffer with the y-axis pointing down.

% number of matching points
no_matches = size(xx1,1);

% operations for note (1) above
x1 = [xx1 ones(size(xx1,1), 1)]';
x2 = [xx2 ones(size(xx2,1), 1)]';
% operations for note (2) above
siz = size(IL);
origin = [siz(2); siz(1)]/2;

axis_x = -origin(1) : (origin(1)-1);
axis_y = (origin(2)-1) : -1 : -origin(2);

% T is the 3-by-3 transformation matrix required for operation (2) above
T = [1 0 -origin(1); 0 -1 origin(2); 0 0 1];
x1 = T*x1;
x2 = T*x2;

% call the simple linear method for computing the fundamental matrix.  This
% is an example on rectification.  Strictly speaking, the non-linear method
% for estimating the fundamental matrix should be employed here.
% [F,errs] = fundmatrix_ls([x1; x2], [], []);

% try replacing the line above with:
opt = lmeds_options('func', 'fundmatrix_nonlin', 'prop_outliers', 0.2, 'inlier_noise_level', 1);
[F,inl,outl,errs,avgerr] = lmeds([x1;x2], opt);

% finally, rectify the two images
[JL, JR, box, HL, HR] = rectify_images(IL, IR, x1, x2, F);

minx = box(1); miny = box(2);
maxx = box(3); maxy = box(4);

% points corresponding to x1 and x2 in the new images are H1*x1 and H2*x2.
newx1 = pflat(HL*x1);
newx2 = pflat(HR*x2);

% -----
% plot the input images
if plot
    % plot the outputs
    figure(3),
    imagesc(minx:maxx, maxy:-1:miny, JL), axis xy, axis on, hold on
    line([minx; maxx]*ones(1,no_matches), [newx1(2,:); newx1(2,:)]);
    %plot(newx1(1,:), newx1(2,:), 'g*')
    axis equal
    title('First rectified image');

    figure(4),
    imagesc(minx:maxx, maxy:-1:miny, JR), axis xy, axis on, hold on
    line([minx; maxx]*ones(1,no_matches), [newx2(2,:); newx2(2,:)]);
    %plot(newx2(1,:), newx2(2,:), 'g*')
    axis equal
    title('Second rectified image');
end

end

