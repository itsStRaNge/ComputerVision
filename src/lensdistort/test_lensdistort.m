function test_lensdistort()
%% load data
IL = rgb2gray(imread('L1.JPG'));
IR = rgb2gray(imread('R1.JPG'));
load('camera_param.mat', 'params');

%% undistort images
IL_d = lensdistort(IL,params.RadialDistortion,params.PrincipalPoint,'bordertype','fit');
IR_d = lensdistort(IR,params.RadialDistortion,params.PrincipalPoint,'bordertype','fit');

%% plot images
subplot(2,2,1);
imshow(IL);
title('Original Left');

subplot(2,2,2);
imshow(IR);
title('Original Right');

subplot(2,2,3);
imshow(IL_d);
title('Undistorted Left');

subplot(2,2,4);
imshow(IR_d);
title('Undistorted Right');
end

