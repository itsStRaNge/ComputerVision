function [matches,E,K,JL,JR,HL,HR]  = preprocessing(IL, IR, camera_param)
%% parse inputs


fprintf('Performing Preprocessing with\n');
fprintf('---------------------------------------------\n');
fprintf('Step\t Task\t\t\t\t Time Est.\tTime\n');

%% undistortion lens from images
fprintf('1\t Undistorting Lens\t\t 1.50s'); 
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
K = camera_param.IntrinsicMatrix';
%% feature extracting
fprintf('2\t Extracting SURF Features\t\t 20.00s'); 
start = tic;
feat = feature_extracting(IL_d,IR_d,false);
fprintf('\t\t%.2fs\n', toc(start));

%% feature matching
fprintf('3\t Feature Matching\t\t 15.00s'); 
start = tic;
matches = feature_matching(feat.P1, feat.D1, feat.P2, feat.D2);
matches = ransac_algorithm(matches(:,1:70), 'epsilon', 0.77, 'tolerance', 0.15);

fprintf('\t\t%.2fs\n', toc(start));

%% get essential matrix
fprintf('3\t Estimate Essential Matrix\t 0.00s'); 
start = tic;
E = eight_point_algorithm(matches, K);
fprintf('\t\t%.2fs\n', toc(start));

%% compute eukledian motion
fprintf('4\t Computing Motion\t\t 0.10s'); 
start = tic;
[R, T, lambda] = motion_estimation(matches, E, K);
fprintf('\t\t%.2fs\n', toc(start));


%% rectify images (crop or not)
fprintf('5\t Apply Rectification\t\t 3.80s');
start = tic;
[JL, JR, HL, HR] = rectification(IL_d, IR_d, R, T', K,1);
fprintf('\t\t%.2fs\n', toc(start));

