function test_rectify_trondheim()
%% load data
IL = rgb2gray(imread('L1_undist.JPG'));
IR = rgb2gray(imread('R1_undist.JPG'));


%% get rectified images
[JL, JR, H1, H2] = rectify_trondheim(IL, IR);

%% plot original and rectified images
subplot(2,2,1);
imshow(IL);
title('Original Left Image');

subplot(2,2,2);
imshow(IR);
title('Original Right Image');

subplot(2,2,3);
imshow(JL);
title('Rectified Left Image');

subplot(2,2,4);
imshow(JR);
title('Rectified Right Image');
save results_trondheim.mat
end
