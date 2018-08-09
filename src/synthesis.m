function [Im3] = synthesis(Im1, disparity, p)
% Based on Disparitymap and rate of shift p
% create a new Image Im3 with a camera on position O3
imshow(imread('disp0-n.pgm'));
imshow(imread('disp1-n.pgm'));
Im3 = zeros(size(Im1));

for x=1:size(disparity, 1)
    for y =1:size(disparity, 2)
        % map pixel from Im1 to Im3
        pos = x + disparity(x, y) * p;
        Im3(pos, y) = Im1(x, y);
    end
end
imshow(Im3);
end

