function [output_image]  = free_viewpoint(IL, IR, camera_param, varargin)
%% parse inputs
g = inputParser; 
g.addOptional('load_disparity_map', true, @islogical);
g.addOptional('p', 0.5, @isnumeric);
ValidDispFac = @(x) isnumeric(x) && (x >= 0.0) && (x <= 1.0);
WinSizeFac = @(x) isnumeric(x) && (x >= 0.0) && (x <= 0.2);
g.addOptional('max_disp_factor', 0.5, ValidDispFac);
g.addOptional('win_size_factor', 0.05, WinSizeFac);
g.parse(varargin{:});
p = g.Results.p;
load_disparity = g.Results.load_disparity_map;
max_disp_factor = g.Results.max_disp_factor;
win_size_factor = g.Results.win_size_factor;

K = camera_param.IntrinsicMatrix';

fprintf('Step\t Task\t\t\t\t Time Est.\tTime\n');
if load_disparity    
    %% depth map 
    fprintf('6/8\t Loading Disparity Map\t\t 0.00s');
    load('disparity_map', 'disparity_map');
    %% TODO resize image IL and IR
else
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


    %% feature matching
    fprintf('2/8\t Extracting Features\t\t 25.00s'); 
    start = tic;
    Corr = feature_extracting_matching(IL_d,IR_d,false);
    fprintf('\t\t%.2fs\n', toc(start));

    %% get essential matrix
    fprintf('3/8\t Estimate Essential Matrix\t 0.00s'); 
    start = tic;
    F = eight_point_algorithm(Corr, K);
    fprintf('\t\t%.2fs\n', toc(start));


    %% compute eukledian motion
    fprintf('4/8\t Computing Motion\t\t 0.10s'); 
    start = tic;
    [R, T] = motion_estimation(Corr, F, K);
    fprintf('\t\t%.2fs\n', toc(start));

    %% rectificate images (crop or not)
    fprintf('5/8\t Apply Rectification\t\t 3.80s');
    start = tic;
    [JL, JR, HomographyL, HomographyR] = rectification(IL, IR, R, T', K,'kit');
    %check if this 
    %[JL,JR,HomographyL,HomographyR]=rectify_trondheim(IL, IR, F, Corr);

    fprintf('\t\t%.2fs\n', toc(start));
    %% depth map 
    fprintf('6/8\t Creating Disparity Map\t\t 34.00s');
    start = tic;
    [disp_left,disp_right] = ...
        calculateDisparityMap(JL,JR,1000,max_disp_factor,win_size_factor);
end
fprintf('\t\t%.2fs\n', toc(start));

%% synthese
fprintf('7/8\t Synthesising new Image\t\t 1.80s');
start = tic;
IM = synthesis_both_sides(disp_left,disp_right,IL,IR,p);
fprintf('\t\t%.2fs\n', toc(start));

%% derectification
% NOTE: not sure what homography matrix to choose
fprintf('8/8\t Inverting Rectification\t 0.10s');
start = tic;
output_image = cv_inv_rectify(IM, HomographyL);
fprintf('\t\t%.2fs\n', toc(start));
end

