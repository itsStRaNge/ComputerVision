function test_rect_with_essential()
%% load data
IL = rgb2gray(imread('L1.JPG'));
IR = rgb2gray(imread('R1.JPG'));
load('camera_param', 'params');
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

%% get projection matrix
P1 = projection(K, eye(3,3), [0,0,0]);
P2 = projection(K, R, T);
[HL, HR, ~, ~] = rectify(K, R, P1, P2);

%% apply homographie matrix
%JL = zeros(size(IL));
%for x=1:size(IL,1)
%    for y=1:size(IL,2)
%    v = HL * [x; y; 1];
%    v = round(v);
%    JL(v(1), v(2)) =  IL(x, y);
%    end
%end
tform = projective2d(HL);
JL = imwarp(IL,tform);

tform = projective2d(HR); 
JR = imwarp(IR,tform);

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

