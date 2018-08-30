function rgbim = compute_lab_space(L_value)

%This function returns an image expressed using the RGB colour model for
%the given L value for the L*a*b* colour model.  The output image can be
%displayed to illustrate the L*a*b* colour space for a fixed L* value.
%
%May 2010
%Copyright Du Huynh
%The University of Western Australia
%School of Computer Science and Software Engineering


% Ranges of values:
% L* values vary from 0 (black) to 100 (white)
% a* values vary from -128 to 128
% b* values ditto

[a,b] = meshgrid(-128:128, -128:128);

labim(:,:,1) = L_value*ones(size(a));
labim(:,:,2) = a;
labim(:,:,3) = b;

% convert to rgb for plotting.  We cannot map L*a*b* to RGB directly.
% Instead, we need to map to the intermediate CIE XYZ space.
rgbim = xyz2rgb(lab2xyz(labim));

% The L*a*b* colour space is larger than the RGB colour space and contains
% colours that cannot be displayed.  The colour is undisplayable if one or
% more channels' values are outside the range 0..255. 
for ii=1:3
    idx = [find(rgbim(:,:,ii) < 0); find(rgbim(:,:,ii) > 255)];
    for jj=1:3
        tmp = rgbim(:,:,jj);
        tmp(idx) = 0;
        rgbim(:,:,jj) = tmp;
    end
end
rgbim = uint8(rgbim);
