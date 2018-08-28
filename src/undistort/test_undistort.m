function test_lensdistort()
%% load data
IL = rgb2gray(imread('L1.JPG'));
IR = rgb2gray(imread('R1.JPG'));
load('camera_param.mat', 'params');

figure
%% undistort images
IL_d = undistort_image(IL,params.FocalLength(1),params.PrincipalPoint(1),params.PrincipalPoint(2),...
                       params.RadialDistortion(1),params.RadialDistortion(2),0,params.TangentialDistortion(1),...
                       params.TangentialDistortion(2));
IR_d = undistort_image(IR,params.FocalLength(1),params.PrincipalPoint(1),params.PrincipalPoint(2),...
                       params.RadialDistortion(1),params.RadialDistortion(2),0,params.TangentialDistortion(1),...
                       params.TangentialDistortion(2));

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

