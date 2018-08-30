function [JL, JR, HL, HR] = cv_rectify(IL, IR, R, T, K)
% Rectification with calibration data
% Adjusted Version for computer vision course at TU Munich
% Modified code from 'rectifyImageE.m'.

%% CREATE PROJECTION MATRICES
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  rectification without centeriing
[HL,HR,~ , ~] = rectify(PL , PR);

% centering LEFT image
p = [size(IL,1)/2; size(IL,2)/2; 1];
px = HL * p;
dL = p(1:2) - px(1:2)./px(3) ;

% centering RIGHT image
p = [size(IR,1)/2; size(IR,2)/2; 1];
px = HR * p;
dR = p(1:2) - px(1:2)./px(3) ;

% vertical diplacement must be the same
dL(2) = dR(2);

%  rectification with centering
[HL,HR,~,~] = rectify(PL,PR,dL,dR);


% find the smallest bb containining both images
bb = mcbb(size(IL),size(IR), HL, HR);

% warp RGB channels,
for c = 1:size(IL, 3)

    % Warp LEFT
    [JL(:,:,c),~,~] = my_imwarp(IL(:,:,c), HL, 'bilinear', bb);

    % Warp RIGHT
    [JR(:,:,c),~,~] = my_imwarp(IR(:,:,c), HR, 'bilinear', bb);

end

