function test_rectification()
%% load and prepare data
IL = imread('L1.JPG');
IR = imread('R1.JPG');
load('camera_param', 'params');
K = params.IntrinsicMatrix';
P1 = projection(K, eye(3,3), [0,0,0]);
P2 = projection(K, eye(3,3), [3,2,0]);

%% compute homography matrices
[HL, HR, ~, ~] = rectification(P1, P2);

%% apply homography matrix HL and HR to images
tform = projective2d(HL); 
JL = imwarp(IL, tform);

tform = projective2d(HR); 
JR = imwarp(IR, tform);

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

