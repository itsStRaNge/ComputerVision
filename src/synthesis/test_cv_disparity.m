function test_cv_disparity()

IL = rgb2gray(imread('im0.png'));
IR = rgb2gray(imread('im1.png'));

disp = cv_disparity(IL, IR);

imagesc(disp);
end