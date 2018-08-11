function test_synthesis()
dispL = imread('disp0-n.pgm');
dispR = imread('disp1-n.pgm');
ImL = imread('im0.png');
ImR = imread('im1.png');

[Im3, Im4] = synthesis(ImL, dispL, ImR, dispR, 0.5);

subplot(3,2,1);
imagesc(ImL);

subplot(3,2,2);
imagesc(ImR);

subplot(3,2,3);
imagesc(dispL);

subplot(3,2,4);
imagesc(dispR);

subplot(3,2,5);
imagesc(Im3);

subplot(3,2,6);
imagesc(Im4);
end