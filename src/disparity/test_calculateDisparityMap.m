%load('rectificated.mat', 'JL');
%load('rectificated.mat', 'JR');
clear
JL=imread('L2_our_recti.png');
JR=imread('R2_our_recti.png');

[disp_left,disp_right,~,~]=calculateDisparityMap(JL,JR,800,0.2,0.06,2,0);

%a=quantile(disp_left(:),0.05);
%b=quantile(disp_left(:),0.95);
%disp_left(disp_left<=a)=a;
%disp_left(disp_left>=b)=-400;

%a=quantile(disp_right(:),0.05);
%b=quantile(disp_right(:),0.95);
%disp_right(disp_right<=a)=a;
%disp_right(disp_right>=b)=-400;

figure
imagesc(disp_left);
figure
imagesc(disp_right);
%save disparity_seq1.mat