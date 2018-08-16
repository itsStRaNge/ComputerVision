function [OutIm] = cv_inv_rectify(InIm, Homography)
Homography = inv(Homography);
% find the smallest bb containining both images
bb = mcbb(size(InIm),size(InIm), Homography, Homography);

% Warp LEFT
[OutIm,~,~] = my_imwarp(InIm, Homography, 'bilinear', bb);
end

