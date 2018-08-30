function [dispmap_left,IL_resized,IR_resized] = calculateDisparityMap(IL,IR,varargin)
%Inputs: IL,IR rectified color images
%        mode - either 'feat' or 'block' to choose the two different modes.
%               block seems to perform better
%Outputs: IL_resized,IR_resized images scaled to save processing power,
%         dispmap_left the disparity map from the left position
defaultMode = 'block';
defaultSize  = 800;
expectedMode= {'block','feat'};

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

%{
if(strcmp(mode,'feat'))
    if(size(varargin(end),1)==4 && size(varargin(end),2)>1 && size(varargin(end),3)==1)
        Corr=varargin(end);
    else
        error('please pass 4xN image correspondence vector as last argument');
    end
end
%}




    if(size(IL)~= size(IR))
        error('images must be the same size');
    end
    if(max(size(IL))>max_image_size)
        size_factor=max_image_size/max(size(IL));
        IL_resized=imresize(IL,size_factor);
        IR_resized=imresize(IR,size_factor);
    end
    if(strcmp('feat',mode))
        dispmap_left=disparity_segmentation(IL_resized,IR_resized,25);
    elseif(strcmp('block',mode))
        dispmap_left=StereoDisp(IL_resized,IR_resized,40,60,11,1);
        
    else
        error('mode not specified correctly');
    end
end

