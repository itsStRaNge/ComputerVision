function [output_image]  = free_viewpoint(IL, IR, camera_param, varargin)
%% parse inputs
g = inputParser; 
g.addOptional('load_disparity_map', true, @islogical);
g.addOptional('p', 0.5, @isnumeric);
ValidDispFac = @(x) isnumeric(x) && (x >= 0.0) && (x <= 1.0);
WinSizeFac = @(x) isnumeric(x) && (x >= 0.0) && (x <= 0.2);
g.addOptional('max_disp_factor', 0.5, ValidDispFac);
g.addOptional('win_size_factor', 0.08, WinSizeFac);
g.parse(varargin{:});
p = g.Results.p;
max_disp_factor = g.Results.max_disp_factor;
win_size_factor = g.Results.win_size_factor;
K = camera_param.IntrinsicMatrix';

fprintf('Step\t Task\t\t\t\t Time Est.\tTime\n');

%% undistortion lens from images
fprintf('1/8\t Undistorting Lens\t\t 1.50s'); 
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

%% feature extracting
fprintf('2/8\t Extracting SURF Features\t\t 20.00s'); 
start = tic;
feat = feature_extracting(IL_d,IR_d,false);
fprintf('\t\t%.2fs\n', toc(start));

%% feature matching
fprintf('2/8\t Feature Matching\t\t 15.00s'); 
start = tic;
matches = feature_matching(feat.P1, feat.D1, feat.P2, feat.D2);
matches = ransac_algorithm(matches(:,1:200), 'epsilon', 0.77, 'tolerance', 0.15);
fprintf('\t\t%.2fs\n', toc(start));

%% get essential matrix
fprintf('3/8\t Estimate Essential Matrix\t 0.00s'); 
start = tic;
E = eight_point_algorithm(matches, K);
fprintf('\t\t%.2fs\n', toc(start));

%% compute eukledian motion
fprintf('4/8\t Computing Motion\t\t 0.10s'); 
start = tic;
[R, T, lambda] = motion_estimation(matches, E, K);
fprintf('\t\t%.2fs\n', toc(start));


%% rectificate images (crop or not)
fprintf('5/8\t Apply Rectification\t\t 3.80s');
start = tic;
[JL, JR, HomographyL, HomographyR] = rectification(IL_d, IR_d, R, T', K);
fprintf('\t\t%.2fs\n', toc(start));

%% depth map 
fprintf('6/8\t Creating Disparity Map\t\t 34.00s');
start = tic;
[disp_left,disp_right,IL_resized,IR_resized] = ...
    calculateDisparityMap(JL,JR,1000,max_disp_factor,win_size_factor, 2,1);
fprintf('\t\t%.2fs\n', toc(start));

%% synthese
fprintf('7/8\t Synthesising new Image\t\t 1.80s');
start = tic;
IM = synthesis_both_sides(disp_left,disp_right, IL_resized, IR_resized, p);
fprintf('\t\t%.2fs\n', toc(start));

%% derectification
fprintf('8/8\t Inverting Rectification\t 0.10s');
start = tic;
if p <= 0.5
    output_image = cv_inv_rectify(IM, HomographyL);
else
    output_image = cv_inv_rectify(IM, HomographyR);
end
fprintf('\t\t%.2fs\n', toc(start));
end
