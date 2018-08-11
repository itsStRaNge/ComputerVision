function [Im3, Im4] = synthesis(ImL, dispL, ImR, dispR, p)
% Based on Disparitymap and rate of shift p
% create a new Image Im3 with a camera on position O3
Im3 = zeros(size(ImL));
Im4 = zeros(size(ImR));

for x=1:size(ImL, 1)
    for y =1:size(ImL, 2)
        % map pixel from ImL to Im3
        pos = x + dispL(x, y) * p;
        Im3(pos, y) = ImL(x, y);

        pos = x + dispR(x, y) * p;
        Im4(pos, y) = ImR(x, y);
    end
end
end

