function [JL, JR] = rectification(IL, IR, R, T, K, mode)
%% available modes ['kit', 'svd', 'cheap']

%% create projection matrix
pi = [1 0 0 0; 0 1 0 0; 0 0 1 0];
[yaw, pitch, roll] = euler_angles(R);
R_half = euler_rotation(yaw/2, pitch/2, roll/2);
M = [R_half, (T/2)'; 0, 0, 0, 1];

PL = K * pi * M;
PR = K * pi * -M;

%% get rectification mode
if strcmp(mode, 'kit')
    [JL, JR] = cv_rectify(IL, PL, IR, PR);
elseif strcmp(mode, 'svd')
    [JL, JR] = rectify_svd(IL, PL, IR, PR);
elseif strcmp(mode, 'cheap')
    [JL, JR] = rectify_cheap(IL, PL, IR, PR);
else
    disp('Invalid Mode selected')
    JL = zeros(size(IL));
    JR = zeros(size(IR));
end

