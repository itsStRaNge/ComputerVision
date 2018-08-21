function [OutIm] = cv_inv_rectify(InIm, Homography)
Homography = inv(Homography);
% find the smallest bb containining both images
bb = mcbb(size(InIm),size(InIm), Homography, Homography);

% warp RGB channels,
for c = 1:size(InIm, 3)
    [OutIm(:,:,c),~,~] = my_imwarp(InIm(:,:,c), Homography, 'bilinear', bb);
end
end

