%um rektifizierung zu überprüfen
I1 = rgb2gray(imread('L2_rect.png'));
I2 = rgb2gray(imread('R2_rect.png'));


points1 = detectSURFFeatures(I1);
points2 = detectSURFFeatures(I2);

[f1,vpts1] = extractFeatures(I1,points1);
[f2,vpts2] = extractFeatures(I2,points2);


indexPairs = matchFeatures(f1,f2) ;
matchedPoints1 = vpts1(indexPairs(:,1));
matchedPoints2 = vpts2(indexPairs(:,2));

figure; showMatchedFeatures(I1,I2,matchedPoints1,matchedPoints2);
legend('matched points 1','matched points 2');