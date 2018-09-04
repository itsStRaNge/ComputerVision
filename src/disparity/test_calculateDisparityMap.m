%load('rectificated.mat', 'JL');
%load('rectificated.mat', 'JR');
clear
JL=imread('teddyL.png');
JR=imread('teddyR.png');

[disp_left,disp_right]=calculateDisparityMap(JL,JR,'mode','match','size',600);

figure
imagesc(disp_left);
figure
imagesc(disp_right);
save disparity_teddy.mat