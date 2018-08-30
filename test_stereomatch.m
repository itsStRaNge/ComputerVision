clear

max_disp=61;
window_size=23;
size_factor=0.3;

I1=imread('chairL.png');
I2=imread('chairR.png');

I1_small=imresize(I1,size_factor);
I2_small=imresize(I2,size_factor);

disp_left=stereomatch(I1_small,I2_small,window_size,max_disp,1);
disp_left=int16(disp_left);
disp_left(disp_left>max_disp)=0;
disp_left(disp_left<0)=0;
disp_large=double(disp_left);
disp_large=imresize(disp_large,[size(I1,1) size(I1,2)]);
disp_large=disp_large*1/size_factor;
disp_large=int16(disp_large);

figure
imagesc(disp_left);


disp_right=stereomatch(fliplr(I2_small),fliplr(I1_small),window_size,max_disp,1);
disp_right=int16(disp_right);
disp_right=fliplr(disp_right);
disp_right(disp_right>max_disp)=0;
disp_right(disp_right<0)=0;

figure
imagesc(disp_right);