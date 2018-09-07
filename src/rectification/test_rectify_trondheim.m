function test_rectify_trondheim()
%% load data
IL = rgb2gray(imread('L1_undist.png'));
IR = rgb2gray(imread('R1_undist.png'));
load('Corr', 'Corr');
load('camera_param', 'params');
K = params.IntrinsicMatrix';

F = eight_point_algorithm(Corr, K);

%% get rectified images
for i=1:10% try until good rectification (or count)
    fprintf('Rectifying, trial %d\n',i)
    [JL,JR,HomographyL,HomographyR, success]=rectify_trondheim(IL, IR, F, Corr);
    if success
        break;
    end
end


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
