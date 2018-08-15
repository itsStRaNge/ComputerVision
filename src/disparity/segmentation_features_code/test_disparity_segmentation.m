clear all;

leftrgb=imread('hatsL.png');          
rightrgb=imread('hatsR.png');  
%%resize image if it takes too long
%leftrgb=imresize(leftrgb,0.25);
%rightrgb=imresize(rightrgb,0.25);

disp_map=disparity_segmentation(leftrgb,rightrgb,17);

save disp_hats.mat disp_map;