function [disp_left,disp_right] = calculateDisparityMap(IL,IR,varargin)
%Inputs: IL,IR rectified color images
%        mode - either 'feat' or 'block' to choose the two different modes.
%               block seems to perform better
%Outputs: IL_resized,IR_resized images scaled to save processing power,
%         dispmap_left the disparity map from the left position

%%% input parsing
defaultMode = 'block';
defaultSize  = 800;

expectedMode= {'block','feat','match'};

p = inputParser;
validSize = @(x) (isnumeric(x));

validImage= @(x) ((isnumeric(x)) && (size(x,1)>1) && (size(x,2)>1) && (size(x,3)==3) && (strcmp(class(x),'uint8')));

addRequired(p,'IL',validImage);
addRequired(p,'IR',validImage);
addParameter(p,'size',defaultSize,validSize);
addParameter(p,'mode',defaultMode,@(X) any(validatestring(X,expectedMode)));

parse(p,IL,IR,varargin{:});
mode=p.Results.mode;
max_image_size=p.Results.size;
%%%end of image parsing


%%%%%%%%%%%%%%%%%%%%%%%%
%%Play with these for different results!
max_disp=0.15*max_image_size;
window_size=(0.05*max_image_size*2)/2 +1;
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
    if(strcmp('feat',mode))
        disp_left=disparity_segmentation(IL_prep,IR_prep,num_clusters);
        disp_right=disparity_segmentation(fliplr(IR_prep),fliplr(IL_prep),num_clusters);
        
    elseif(strcmp('block',mode))
        
        disp_left=StereoDisp(IL_prep,IR_prep,num_clusters,max_disp,window_size,1);
        disp_right=StereoDisp(fliplr(IR_prep),fliplr(IL_prep),num_clusters,max_disp,window_size,1);
        
    elseif(strcmp('match',mode))
        disp_left =stereomatch(IL_prep,IR_prep,window_size,max_disp,1);
        disp_right=stereomatch(fliplr(IR_prep),fliplr(IL_prep),window_size,max_disp,1);
        disp_right=fliplr(disp_right);
        
    else
        error('mode not specified correctly');
    end
    
    %size back to original:
    disp_left=imresize(disp_left,[size(IL,1),size(IL,2)]);
    disp_right=imresize(disp_right,[size(IR,1),size(IR,2)]);
    disp_left=disp_left*(1/size_factor);
    disp_right=disp_right*(1/size_factor);
end

