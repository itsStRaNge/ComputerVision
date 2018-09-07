function [JL, JR, HL, HR] = cv_rectify(IL, PL, IR, PR)
% Rectification with calibration data
% Adjusted Version for computer vision course at TU Munich
% Modified code from 'rectifyImageE.m'.

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
    [JR(:,:,c),~,~] = my_imwarp(IR(:,:,c), -HR, 'bilinear', bb);

end





