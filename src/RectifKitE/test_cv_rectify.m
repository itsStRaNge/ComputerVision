function test_cv_rectify()
IL = imread('L1.JPG');
IR = imread('R1.JPG');

load('data/calibration');

[JL, JR] = cv_rectify(IL, KL, IR, KR);


% -------------------- PLOT LEFT VIEW
%figure(1)
subplot(2,2,1)
image(IL);
axis image
title('Left image');

% -------------------- PLOT RIGHT VIEW
%figure(2)
subplot(2,2,2)
image(IR);
axis image
title('Right image');

% -------------------- PLOT LEFT
%figure(3)
subplot(2,2,3)
image(JL);
axis image
hold on
title('Rectified left image');


% --------------------  PLOT RIGHT
%figure(4)
subplot(2,2,4)
image(JR);
axis image
hold on
title('Rectified right image')

end