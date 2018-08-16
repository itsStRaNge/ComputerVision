function test_feature_extraction()
%% Load images
IL=imread('data/L1.JPG');
IR=imread('data/R1.JPG');
load('data/camera_param.mat', 'params');
K = params.IntrinsicMatrix;
%% do feature extraction
Corr = feature_extracting_matching(IL,IR,true);

%% get essential matrix
E = eight_point_algorithm(Corr, K);

%% compute eukledian motion
[R, T] = motion_estimation(Corr, E, K);
end
 