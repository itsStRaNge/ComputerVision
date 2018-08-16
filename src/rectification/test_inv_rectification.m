function test_inv_rectification()
%% load data
IL = rgb2gray(imread('data/L1.JPG'));
IR = rgb2gray(imread('data/R1.JPG'));
load('data/camera_param', 'params');
K = params.IntrinsicMatrix';

%% get essential matrix
imagePoints1 = detectSURFFeatures(IL);
imagePoints2 = detectSURFFeatures(IR);
features1 = extractFeatures(IL,imagePoints1,'Upright',true);
features2 = extractFeatures(IR,imagePoints2,'Upright',true);
indexPairs = matchFeatures(features1,features2);
matchedPoints1 = imagePoints1(indexPairs(:,1));
matchedPoints2 = imagePoints2(indexPairs(:,2));
[E,~] = estimateEssentialMatrix(matchedPoints1,matchedPoints2,params);

%% get rotation and translation
[R,T] = relativeCameraPose(E,params,matchedPoints1,matchedPoints2);


%% get rectified images
[JL, JR, HL, HR] = rectification(IL, IR, R, T, K,'kit');

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
