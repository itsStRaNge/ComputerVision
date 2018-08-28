function [output_image]  = free_viewpoint(IL, IR, camera_param, varargin)
%% parse inputs
g = inputParser;
g.addOptional("p", 0.5, @isnumeric);
g.parse(varargin{:});
p = g.Results.p;
K = camera_param.IntrinsicMatrix';

fprintf('Step\t Task\t\t\t\t Time Est.\tTime\n');

%% undistortion lens from images
fprintf('1/8\t Undistorting Lens\t\t 9.00s'); 
start = tic;
IL_d = undistort_image(IL,camera_param.FocalLength(1),camera_param.PrincipalPoint(1),...
                       camera_param.PrincipalPoint(2),...
                       camera_param.RadialDistortion(1),...
                       camera_param.RadialDistortion(2),...
                       0,...
                       camera_param.TangentialDistortion(1),...
                       camera_param.TangentialDistortion(2));
IR_d = undistort_image(IR,camera_param.FocalLength(1),camera_param.PrincipalPoint(1),...
                       camera_param.PrincipalPoint(2),...
                       camera_param.RadialDistortion(1),...
                       camera_param.RadialDistortion(2),...
                       0,...
                       camera_param.TangentialDistortion(1),...
                       camera_param.TangentialDistortion(2));
fprintf('\t\t%.2fs\n', toc(start));

%% feature matching
fprintf('2/8\t Extracting Features\t\t 26.00s'); 
start = tic;
Corr = feature_extracting_matching(IL_d,IR_d,false);
fprintf('\t\t%.2fs\n', toc(start));

%% get essential matrix
fprintf('3/8\t Estimate Essential Matrix\t 0.00s'); 
start = tic;
E = eight_point_algorithm(Corr, K);
fprintf('\t\t%.2fs\n', toc(start));

%% compute eukledian motion
fprintf('4/8\t Computing Motion\t\t 0.20s'); 
start = tic;
[R, T] = motion_estimation(Corr, E, K);
fprintf('\t\t%.2fs\n', toc(start));

%% rectificate images (crop or not)
fprintf('5/8\t Apply Rectification\t\t 4.00s');
start = tic;
[JL, JR, HomographyL, HomographyR] = rectification(IL, IR, R, T', K,'kit');
fprintf('\t\t%.2fs\n', toc(start));

%% depth map 
% TODO: evt zweite disparity map für rechtes bild berechnen
% TODO: disparity map fct umschreiben, sodass korrespondenzpunkte
% übergeweben werden können
fprintf('6/8\t Creating Disparity Map\t\t 35.00s');
start = tic;
[disparity_map,IL_resized,IR_resized] = calculateDisparityMap(JL,JR,'mode','block','size',800);
fprintf('\t\t%.2fs\n', toc(start));

%% synthese
% NOTE: alle verabeitungsschritte vorher nur einmal auszuführen
%       synthese wird bei jedem neuen p durchgeführt
% TODO: holefilling nochmal anschaun
fprintf('7/8\t Synthesising new Image\t\t 2.00s');
start = tic;
IM = synthesis(disparity_map, IL_resized, IR_resized, p);
fprintf('\t\t%.2fs\n', toc(start));

%% derectification
% NOTE: not sure what homography matrix to choose
fprintf('8/8\t Inverting Rectification\t 0.10s');
start = tic;
output_image = cv_inv_rectify(IM, HomographyL);
fprintf('\t\t%.2fs\n', toc(start));
end

