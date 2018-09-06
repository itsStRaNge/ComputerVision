function [disp_left,disp_right] = calculateDisparityMap(IL,IR,max_image_size,max_disp_factor,window_size_factor)
%Inputs: IL,IR rectified color images
%        mode - either 'feat' or 'block' to choose the two different modes.
%               block seems to perform better
%Outputs: IL_resized,IR_resized images scaled to save processing power,
%         dispmap_left the disparity map from the left position

%%%%%%%%%%%%%%%%%%%%%%%%
%%Play with these for different results!
max_disp=max_disp_factor*max_image_size;
window_size=(window_size_factor*max_image_size*2)/2 +1;
num_clusters=25;
%%%%%%%%%%%%%%%%%%%%%%%%



%%preprocessing, gain and bias compensation has to be tested!
IL_prep=double(IL);
IR_prep=double(IR);
IL_prep=IL_prep-mean(IL_prep(:));
IR_prep=IR_prep-mean(IR_prep(:));
IL_prep=IL_prep/std(IL_prep(:));
IR_prep=IR_prep/std(IR_prep(:));

if(size(IL)~= size(IR))
    error('images must be the same size');
end
if(max(size(IL))>max_image_size)
    size_factor=max_image_size/max(size(IL));
    IL_prep=imresize(IL_prep,size_factor);
    IR_prep=imresize(IR_prep,size_factor);
    
    %save uncompensated images for output
end

%%end of preprocessing
  
        disp_left =stereomatch(IL_prep,IR_prep,window_size,max_disp,0);
        disp_right=stereomatch(fliplr(IR_prep),fliplr(IL_prep),window_size,max_disp,0);
        disp_right=fliplr(disp_right);
        
    
    %check for bad vals
    disp_left(disp_left>=max_disp)=max_disp;
    disp_left(disp_left<=-max_disp)=-max_disp;
    disp_right(disp_right>=max_disp)=max_disp;
    disp_right(disp_right<=-max_disp)=-max_disp;
    
    %size back to original if needed
    if(size(IL,1)>max_image_size ||size(IL,2)>max_image_size)
        
        disp_left=imresize(disp_left,[size(IL,1),size(IL,2)]);
        disp_right=imresize(disp_right,[size(IR,1),size(IR,2)]);
        disp_left=disp_left*(1/size_factor);
        disp_right=disp_right*(1/size_factor);
        disp_left=int16(disp_left);
        disp_right=int16(disp_right);
    end
    
end

