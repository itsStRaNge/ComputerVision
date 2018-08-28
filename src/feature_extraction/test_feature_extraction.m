function test_feature_extraction()
%% Load images
load('lens_distr_l.mat', 'IL_d');
load('lens_distr_r.mat', 'IR_d');
load('camera_param.mat', 'params');
K = params.IntrinsicMatrix';

%% do feature extraction
Corr = feature_extracting_matching(IL_d,IR_d,true);

%% get essential matrix
E = eight_point_algorithm(Corr, K);

%% compute eukledian motion
[R, T] = motion_estimation(Corr, E, K);
disp(R);
disp(T);
end
 