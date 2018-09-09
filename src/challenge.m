%% Computer Vision Challenge
close all;
clear;
% Groupnumber:
group_number = 37;

% Groupmembers:
members = {'Alexander Lechthaler', 'Patrick von Velasco', 'Lukas Bernhard', 'Thomas Hartmann'};

% Email-Adress (from Moodle!):
mail = {'alexander.lechthaler@tum.de', 'ga38kon@mytum.de', 'l.bernhard@tum.de', 't.hartmann@tum.de'};

%% Load images and K
IL=imread('L2.JPG');
IR=imread('R2.JPG');

%% load camera params
load('camera_param_1.mat', 'camera_param');

%% count time
tic;

%% create new image
output_image = free_viewpoint(IL, IR, camera_param, 'p', 0.5);

%% stop time
fprintf('End\t Total Time\t\t\t\t\t%.2fs\n', toc);

%% Display Output
imshow(output_image);