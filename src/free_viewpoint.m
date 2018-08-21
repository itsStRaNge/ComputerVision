function [output_image]  = free_viewpoint(IL, IR, varargin)
%% parse inputs
g = inputParser;
g.addOptional("p", 0.5, @isnumeric);
g.parse(varargin{:});
p = g.Results.p;

%% load camera params
disp('Load camera parameters');
load('camera_param_1.mat', 'camera_param');
K = camera_param.IntrinsicMatrix';

%% undistortion lens from images
%IL=lensdistort(IL,camera_param.RadialDistortion,camera_param.PrincipalPoint, ...
   % 'bordertype','fit');
%IR=lensdistort(IR,camera_param.RadialDistortion,camera_param.PrincipalPoint, ...
    %'bordertype','fit');

%% feature matching
disp('extract features');
Corr = feature_extracting_matching(IL,IR,false);

% get essential matrix
disp('estimate essential matrix');
E = eight_point_algorithm(Corr, K);

% compute eukledian motion
disp('compute eukledian motion');
[R, T] = motion_estimation(Corr, E, K);

%% rectificate images (crop or not)
disp('apply rectification');
[JL, JR, HomographyL, HomographyR] = rectification(IL, IR, R, T', K,'kit');

%% depth map 
% TODO: evt zweite disparity map für rechtes bild berechnen
% TODO: disparity map fct umschreiben, sodass korrespondenzpunkte
% übergeweben werden können
disp('compute disparity map');
[disparity_map,IL_resized,IR_resized] = calculateDisparityMap(JL,JR,'block',800);

%% synthese
% NOTE: alle verabeitungsschritte vorher nur einmal auszuführen
%       synthese wird bei jedem neuen p durchgeführt
% TODO: holefilling nochmal anschaun
disp('synthesis new image');
IM = synthesis(disparity_map, IL_resized, IR_resized, p);

%% derectification
% NOTE: not sure what homography matrix to choose
disp('inverse rectification');
output_image = cv_inv_rectify(IM, HomographyL);
end

