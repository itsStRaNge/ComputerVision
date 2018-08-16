function [disparity_map, homography] = preprocessing(IL, IR, params)
K = params.IntrinsicMatrix;

%% undistortion lens from images
IL=lensdistort(IL,params.RadialDistortion,params.PrincipalPoint,'bordertype','fit');
IR=lensdistort(IR,params.RadialDistortion,params.PrincipalPoint,'bordertype','fit');

%% feature matching
Corr = feature_extracting_matching(IL,IR,false);

% get essential matrix
E = eight_point_algorithm(Corr, K);

% compute eukledian motion
[R, T] = motion_estimation(Corr, E, K);

%% rectificate images (crop or not)
[JL, JR, HomographyL, HomographyR] = rectification(IL, IR, R, T, K,'kit');

%% depth map 
% TODO: evt zweite disparity map für rechtes bild berechnen
% input rectified images, punktkorrespondenzen
% output depth map
disparity_map = 0;
homography = HomographyL;
end

