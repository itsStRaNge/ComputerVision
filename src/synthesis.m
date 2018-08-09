function [Im3] = synthesis(disparity, p)
% Based on Disparitymap and rate of shift p
% create a new Image Im3 with a camera on position O3
Im3 = disparity * p;
end

