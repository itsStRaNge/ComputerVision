window_size=5;

Image1=imread('im0.png');
Image1=rgb2gray(Image1);
Image1=double(Image1);
I1=normalizeImage(Image1);

%I1=I1(1000:1400,1000:1400);

Image2=imread('im1.png');
Image2=rgb2gray(Image2);
Image2=double(Image2);
I2=normalizeImage(Image2);
%I2=I2(1000:1400,1000:1400);

dispIm =stereo_match_premade_code(I1,I2,155,150,0);

%dispIm = stereo_match(I1,I2,window_size);
figure;
imagesc(dispIm);

%imshow(dispIm);