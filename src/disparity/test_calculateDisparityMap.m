%load('rectificated.mat', 'JL');
%load('rectificated.mat', 'JR');
clear
JL=imread('bikeL.png');
JR=imread('bikeR.png');
window_size=0.005;
max_disp_factor=0.2;


[disp_left,disp_right,~,~]=calculateDisparityMap(JL,JR,1000,max_disp_factor,window_size,2,1,20);

figure
imagesc(disp_left);
figure
imagesc(disp_right);
%save disparity_seq1.mat
%*3 -294