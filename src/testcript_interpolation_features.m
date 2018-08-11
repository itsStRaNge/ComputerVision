I1gray=rgb2gray(imread('iml.png'));
I2gray=rgb2gray(imread('imr.png'));

imagePoints1 = detectSURFFeatures(I1gray);
imagePoints2 = detectSURFFeatures(I2gray);

features1 = extractFeatures(I1gray,imagePoints1,'Upright',true);
features2 = extractFeatures(I2gray,imagePoints2,'Upright',true);

indexPairs = matchFeatures(features1,features2);
matchedPoints1 = imagePoints1(indexPairs(:,1));
matchedPoints2 = imagePoints2(indexPairs(:,2));

    diff_p=matchedPoints1(:).Location-matchedPoints2(:).Location;
    matchedPoints1(abs(diff_p(:,2))>10)=[];
    matchedPoints2(abs(diff_p(:,2))>10)=[];

figure
showMatchedFeatures(I1gray,I2gray,matchedPoints1,matchedPoints2);
diff_p=matchedPoints1(:).Location-matchedPoints2(:).Location;



displeft=zeros(size(I1gray));
for i=1:size(matchedPoints1,1)
    loc(i,:)=matchedPoints1(i).Location;
    loc(i,:)=round(loc(i,:));
end


loc=double(loc);
diff_p=double(diff_p);

F=scatteredInterpolant(loc(:,2),loc(:,1),diff_p(:,1));

for i=1:size(I1gray,1)
    for j=1:size(I1gray,2)
        displeft(i,j)=F(i,j);
    end
end
figure
imagesc(displeft);



