function [JL, JR] = cv_rectify(IL, KL, IR, KR)
% Rectification with calibration data
% Adjusted Version for computer vision course at TU Munich
% Modified code from 'rectifyImageE.m'.

%  rectification without centeriing
[TL,TR,~ , ~] = rectify(KL , KR);

% centering LEFT image
p = [size(IL,1)/2; size(IL,2)/2; 1];
px = TL * p;
dL = p(1:2) - px(1:2)./px(3) ;

% centering RIGHT image
p = [size(IR,1)/2; size(IR,2)/2; 1];
px = TR * p;
dR = p(1:2) - px(1:2)./px(3) ;

% vertical diplacement must be the same
dL(2) = dR(2);

%  rectification with centering
[TL,TR,~,~] = rectify(KL,KR,dL,dR);


% find the smallest bb containining both images
bb = mcbb(size(IL),size(IR), TL, TR);
TL
TR
% warp RGB channels,
for c = 1:3

    % Warp LEFT
    [JL(:,:,c),~,~] = imwarp(IL(:,:,c), TL, 'bilinear', bb);

    % Warp RIGHT
    [JR(:,:,c),~,~] = imwarp(IR(:,:,c), TR, 'bilinear', bb);

end

