function test_rectification()

IL = rgb2gray(imread('L1.JPG'));
IR = rgb2gray(imread('R1.JPG'));
load('camera_param', 'params');
K = params.IntrinsicMatrix';
P1 = projection(K, eye(3,3), [0,0,0]);
P2 = projection(K, eye(3,3), [3,2,0]);

[TL, TR, ~, ~] = rectification(P1, P2);


bb = mcbb(size(IL),size(IR), TL, TR);

% Warp Images
[JL,~,~] = imwarp(IL, TL, 'bilinear', bb);
[JR,~,~] = imwarp(IR, TR, 'bilinear', bb);

subplot(2,2,1);
imshow(IL);
subplot(2,2,2);
imshow(IR);
subplot(2,2,3);
imshow(JL);
subplot(2,2,4);
imshow(JR);
end

