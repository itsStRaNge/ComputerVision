function [dispmap_left,IL_resized,IR_resized] = calculateDisparityMap(IL,IR,mode,max_image_size)
%Inputs: IL,IR rectified color images
%        mode - either 'feat' or 'block' to choose the two different modes.
%               block seems to perform better
%Outputs: IL_resized,IR_resized images scaled to save processing power,
%         dispmap_left the disparity map from the left position
    if(size(IL)~= size(IR))
        error('images must be the same size');
    end
    if(max(size(IL))>max_image_size)
        size_factor=max_image_size/max(size(IL));
        IL_resized=imresize(IL,size_factor);
        IR_resized=imresize(IR,size_factor);
    end
    if(strcmp('feat',mode))
        dispmap_left=disparity_segmentation(IL_resized,IR_resized,15);
    elseif(strcmp('block',mode))
        dispmap_left=StereoDisp(IL_resized,IR_resized,17,100,35,1);
    else
        error('mode not specified correctly');
    end
    figure
    imagesc(dispmap_left);
end

