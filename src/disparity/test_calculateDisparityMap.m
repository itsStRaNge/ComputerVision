%load('rectificated.mat', 'JL');
%load('rectificated.mat', 'JR');
clear
L2_rect=imread('bikeL.png');
R2_rect=imread('bikeR.png');

dispMap=calculateDisparityMap(R2_rect,L2_rect,'mode','block','size',400);
imagesc(dispMap);
