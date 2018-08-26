function [disparity_map, homography] = preprocessing(IL, IR, params, console)
K = params.IntrinsicMatrix;

%% undistortion lens from images
print_console(console, 'Undistort lens');
IL=lensdistort(IL,params.RadialDistortion,params.PrincipalPoint,'bordertype','fit');
IR=lensdistort(IR,params.RadialDistortion,params.PrincipalPoint,'bordertype','fit');

%% feature matching
print_console(console, 'Extracting Features');
Corr = feature_extracting_matching(IL,IR,false);

% get essential matrix
print_console(console, 'Calculating Essential Matrix');
E = eight_point_algorithm(Corr, K);

% compute eukledian motion
print_console(console, 'Calculating Eukledian Motion');
[R, T] = motion_estimation(Corr, E, K);

%% rectificate images (crop or not)
print_console(console, 'Rectifing Images');
[JL, JR, HomographyL, HomographyR] = rectification(IL, IR, R, T, K,'kit');

%% depth map 
% TODO: evt zweite disparity map für rechtes bild berechnen
% input rectified images, punktkorrespondenzen
% output depth map
disparity_map = 0;
homography = HomographyL;
end

