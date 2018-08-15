function [IL, IR] = cv_inv_rectify(JL, HL, JR, HR)
% Derectification for two Images
IL = zeros(size(JL));
IR = zeros(size(JR));

HL = inv(HL);
HR = inv(HR);
% find the smallest bb containining both images
bb = mcbb(size(JL),size(JR), HL, HR);


% Warp LEFT
[IL,~,~] = my_imwarp(JL, HL, 'bilinear', bb);

% Warp RIGHT
[IR,~,~] = my_imwarp(JR, HR, 'bilinear', bb);

end

