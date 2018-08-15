IL=imread('im0.png');
IL=rgb2gray(IL);

IR=imread('im1.png');
IR=rgb2gray(IR);


dispmap=cv_disparity(IL,IR);
figure
imshow(dispmap);
