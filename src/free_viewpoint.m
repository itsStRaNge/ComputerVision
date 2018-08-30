function [output_image]  = free_viewpoint(IL, IR, camera_param, varargin)
%% parse inputs
g = inputParser; 
g.addOptional("load_disparity_map", true, @islogical);
g.addOptional("load_motion", true, @islogical);
g.addOptional("p", 0.5, @isnumeric);
g.addOptional("gui_console", 0);
g.parse(varargin{:});
p = g.Results.p;
load_disparity = g.Results.load_disparity_map;
load_motion = g.Results.load_motion;
gui_console = g.Results.gui_console;

K = camera_param.IntrinsicMatrix';

print_console(gui_console, 'Step\t Task\t\t\t\t Time Est.\tTime\n');

%% undistortion lens from images
print_console(gui_console, '1/8\t Undistorting Lens\t\t 1.50s'); 
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
print_console(gui_console, sprintf('\t\t%.2fs\n', toc(start)));


if load_motion
    load('eukledian_motion', 'R');
    load('eukledian_motion', 'T');
else
    %% feature matching
    print_console(gui_console, '2/8\t Extracting Features\t\t 25.00s'); 
    start = tic;
    Corr = feature_extracting_matching(IL_d,IR_d,false);
    print_console(gui_console, sprintf('\t\t%.2fs\n', toc(start)));

    %% get essential matrix
    print_console(gui_console, '3/8\t Estimate Essential Matrix\t 0.00s'); 
    start = tic;
    E = eight_point_algorithm(Corr, K);
    print_console(gui_console, sprintf('\t\t%.2fs\n', toc(start)));


    %% compute eukledian motion
    print_console(gui_console, '4/8\t Computing Motion\t\t 0.10s'); 
    start = tic;
    [R, T] = motion_estimation(Corr, E, K);
    print_console(gui_console, sprintf('\t\t%.2fs\n', toc(start)));
end

%% rectificate images (crop or not)
print_console(gui_console, '5/8\t Apply Rectification\t\t 3.80s');
start = tic;
%[JL, JR, HomographyL, HomographyR] = rectification(IL, IR, R, T', K,'kit');
[JL, JR, HomographyL, HomographyR] = du_rectification(IL, IR, Corr, false);
print_console(gui_console, sprintf('\t\t%.2fs\n', toc(start)));

%% depth map 
if load_disparity
    print_console(gui_console, '6/8\t Loading Disparity Map\t\t 0.00s');
    load('disparity_map', 'disparity_map');
    %% TODO resize image IL and IR
else
    print_console(gui_console, '6/8\t Creating Disparity Map\t\t 34.00s');
    start = tic;
    [disparity_map,IL_resized,IR_resized] = calculateDisparityMap(JL,JR,'mode','block','size',800);
end
print_console(gui_console, sprintf('\t\t%.2fs\n', toc(start)));

%% synthese
print_console(gui_console, '7/8\t Synthesising new Image\t\t 1.80s');
start = tic;
IM = synthesis(disparity_map, IL_resized, IR_resized, p);
print_console(gui_console, sprintf('\t\t%.2fs\n', toc(start)));

%% derectification
% NOTE: not sure what homography matrix to choose
print_console(gui_console, '8/8\t Inverting Rectification\t 0.10s');
start = tic;
output_image = cv_inv_rectify(IM, HomographyL);
print_console(gui_console, sprintf('\t\t%.2fs\n', toc(start)));
end

