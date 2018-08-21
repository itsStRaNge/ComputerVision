function test_inv_rectification()
%% load data
load('rectificated', 'HomographyL');
load('synthesis', 'outputImage');

%% inverse rectification
JL = cv_inv_rectify(outputImage, HomographyL);

%% plot original and rectified images
subplot(1,2,1);
imshow(outputImage);
title('Original Image');

subplot(1,2,2);
imshow(JL);
title('Derectified Image');

end
