%% Computer Vision Challenge

% Groupnumber:
group_number = 37;

% Groupmembers:
members = {'Alexander Lechthaler', 'Patrick von Velasco', 'Lukas Bernhard'};

% Email-Adress (from Moodle!):
mail = {'alexander.lechthaler@tum.de', 'ga38kon@mytum.de', 'l.bernhard@tum.de'};

%% Load images and K
IL = imread('L2.JPG');
IR = imread('R2.JPG');

%% count time
tic;

%% create new image
output_image = free_viewpoint(IL, IR);

%% stop time
elapsed_time = toc;

%% Display Output
disp(elapsed_time);
imshow(output_image);