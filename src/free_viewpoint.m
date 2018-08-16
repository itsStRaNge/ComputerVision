function [output_image]  = free_viewpoint(IL, IR, varargin)
%% parse inputs
g = inputParser;
validP = @(x) isnumeric(x);
addOptional(g, "p", 0.5, validP);
p = g.Results.p;

%% load camera params
load('camera_param_1.mat', 'camera_param');
K = camera_param.IntrinsicMatrix;

%% undistortion lens from images
IL=lensdistort(IL,params.RadialDistortion,params.PrincipalPoint,'bordertype','fit');
IR=lensdistort(IR,params.RadialDistortion,params.PrincipalPoint,'bordertype','fit');

%% feature matching
Corr = feature_extracting_matching(I1,I2,false);

% get essential matrix
E = eight_point_algorithm(Corr, K);

% compute eukledian motion
[R, T] = motion_estimation(Corr, E, K);

%% rectificate images (crop or not)
[JL, JR, HomographyL, HomographyR] = rectification(IL, IR, R, T, K,'kit');

%% depth map 
% TODO: evt zweite disparity map für rechtes bild berechnen
% TODO: disparity map fct umschreiben, sodass korrespondenzpunkte
% übergeweben werden können
disparity_map = calculateDisparityMap(JL,JR,'block',800);

%% synthese
% NOTE: alle verabeitungsschritte vorher nur einmal auszuführen
%       synthese wird bei jedem neuen p durchgeführt
% TODO: holefilling nochmal anschaun
IM = synthesis(disparity_map, IL, IR, p);

%% derectification
% NOTE: not sure what homography matrix to choose
output_image = cv_inv_rectify(IM, HomographyL);
end

