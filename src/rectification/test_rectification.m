function test_rectification()
%% load data
IL = rgb2gray(imread('L1.JPG'));
IR = rgb2gray(imread('R1.JPG'));
load('camera_param', 'params');
K = params.IntrinsicMatrix';
IL=lensdistort(IL,params.RadialDistortion,params.PrincipalPoint,'bordertype','fit');
IR=lensdistort(IR,params.RadialDistortion,params.PrincipalPoint,'bordertype','fit');


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
[JL, JR] = rectification(IL, IR, R, T, K,'kit');


%% plot original and rectified images
subplot(2,2,1);
imshow(IL);
subplot(2,2,2);
imshow(IR);
subplot(2,2,3);
imshow(JL);
subplot(2,2,4);
imshow(JR);
end
