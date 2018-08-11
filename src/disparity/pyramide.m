function pyramide(leftI, rightI)

% Construct a three‐level pyramid
pyramids = cell(1,4);
pyramids{1}.L = leftI;
pyramids{1}.R = rightI;
for i=2:length(pyramids)
    hPyr = vision.Pyramid('PyramidLevel',1);
    pyramids{i}.L = single(step(hPyr,pyramids{i-1}.L));
    pyramids{i}.R = single(step(hPyr,pyramids{i-1}.R));
end

% Declare original search radius as +/‐4 disparities for every pixel.
smallRange = single(3);
disparityMin = repmat(-smallRange, size(pyramids{end}.L));
disparityMax = repmat( smallRange, size(pyramids{end}.L));
% Do telescoping search over pyramid levels.
for i=length(pyramids):-1:1
    Dpyramid = stereoDisparity(pyramids{i}.L,pyramids{i}.R, ...
        disparityMin,disparityMax, 3);
    if i > 1
    % Scale disparity values for next level.
    Dpyramid = imresize(Dpyramid, size(pyramids{i-1}.L), 'bilinear');
    % Maintain search radius of +/‐smallRange.
    disparityMin = Dpyramid - smallRange;
    disparityMax = Dpyramid + smallRange;
    end
end
figure(3), clf;
imshow(Dpyramid,[]), colormap('jet'), colorbar, axis image;
caxis([0 disparityRange]);
title('Four‐level pyramid block matching');
end