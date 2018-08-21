function test_inv_rectification()
%% load data
IL = rgb2gray(imread('L1.JPG'));
IR = rgb2gray(imread('R1.JPG'));
load('camera_param', 'params');
load('r_t', 'R');
load('r_t', 'T');

%% get rectified images
[JL, JR, HL, HR] = rectification(IL, IR, R, T', params.IntrinsicMatrix','kit');

%% inverse rectification
IL1 = cv_inv_rectify(JL, HL);
IR1 = cv_inv_rectify(JR, HR);

%% plot original and rectified images
subplot(2,2,1);
imshow(IL);
title('Original Left Image');

subplot(2,2,2);
imshow(IR);
title('Original Right Image');

subplot(2,2,3);
imshow(IL1);
title('Derectified Left Image');

subplot(2,2,4);
imshow(IR1);
title('Derectified Right Image');

end
