function [JL, JR, HL, HR] = rectification(IL, IR, R, T, K, mode)
%% available modes ['kit', 'svd', 'cheap']

%% create projection matrix
pi_matrix = [1 0 0 0; 0 1 0 0; 0 0 1 0];

[yaw, pitch, roll] = euler_angles(R); 
R_half = euler_rotation(yaw/2, pitch/2, roll/2);
%R_half = euler_rotation(0/2, 5/2, 4/2);

%% move both cameras um M / 2
%M = [R_half, (T)'; 0, 0, 0, 1];
%PL = K * pi_matrix * -M;
%PR = K * pi_matrix * M;
M = [R_half, T'];
ML = [1 0 0 0;0 1 0 0; 0 0 1 0];
PL = K * ML ;
PR = K * M;

%% cam 1 in origin
%M = [R, (T)'; 0, 0, 0, 1];
% PL = K * pi_matrix * eye(4,4);
% PR = K * pi_matrix * M;

%% get rectification mode
if strcmp(mode, 'kit')
    [JL, JR, HL, HR] = cv_rectify(IL, PL, IR, PR);
elseif strcmp(mode, 'du')
    load('corr', 'Corr');
    [JL, JR, HL, HR] = du_rectification(IL, IR, Corr, false);
else
    disp('Invalid Mode selected')
    JL = zeros(size(IL));
    JR = zeros(size(IR));
    HL = zeros(3,3);
    HR = zeros(3,3);
end

