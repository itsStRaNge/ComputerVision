%load('rectificated.mat', 'JL');
%load('rectificated.mat', 'JR');
clear
JL=imread('L2_rect.png');
JR=imread('R2_rect.png');
offset=400;

%add padding to the image so that all disp is positive
bm=zeros(size(JL,1),offset,3,'uint8');

JL=[bm JL];
JR=[JR bm];

[disp_left,disp_right]=calculateDisparityMap(JL,JR,1000,0.5,0.05);

%subtract padding
disp_left=disp_left(:,(offset+1):end,:);
disp_right=disp_right(:,1:(size(JL,2)-offset),:);
JL=JL(:,(offset+1):end,:);
JR=JR(:,1:(size(JR,2)-offset),:);
disp_left=disp_left-offset;
disp_right=disp_right-offset;


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