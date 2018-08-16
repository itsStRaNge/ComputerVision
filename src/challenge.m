%% Computer Vision Challenge

% Groupnumber:
group_number = 37;

% Groupmembers:
members = {'Alexander Lechthaler', 'Patrick von Velasco', 'Lukas Bernhard'};

% Email-Adress (from Moodle!):
mail = {'l.bernhard@tum.de'};

%% Load images and K
IL = imread('L1.JPG');
IR = imread('R1.JPG');
load('camera_param_1.mat');
K = camera_param.IntrinsicMatrix;

%% count time
tic;

%% undistortion lens from images
IL=lensdistort(IL,params.RadialDistortion,params.PrincipalPoint,'bordertype','fit');
IR=lensdistort(IR,params.RadialDistortion,params.PrincipalPoint,'bordertype','fit');

%% feature matching
% Output: 
% E, R, T
% List of corresponding features

%% rectificate images (crop or not)
[JL, JR, HomographyL, HomographyR] = rectification(IL, IR, R, T, K,'kit');

%% depth map 
% TODO: evt zweite disparity map für rechtes bild berechnen
% input rectified images, punktkorrespondenzen
% output depth map

%% synthese
% NOTE: alle verabeitungsschritte vorher nur einmal auszuführen
%       synthese wird bei jedem neuen p durchgeführt
% TODO: holefilling nochmal anschaun
IM = synthesis(disparity_map, IL, IR, p);

%% derectification
% NOTE: not sure what homography matrix to choose
finalImage = cv_inv_rectify(IM, HomographyL);

elapsed_time = toc;

%% Display Output
disp(elapsed_time);
imshow(finalImage);