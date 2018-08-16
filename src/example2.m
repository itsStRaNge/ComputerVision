close all;
% Example 2, Corresponding points
% Load images
%I1=imread('TestImages/lena1.png');
%I2=imread('TestImages/lena2.png');
I1=imread('TestImages/L1.JPG');
I2=imread('TestImages/R1.JPG');

m = feature_extracting_matching(I1,I2,true);

K = calibration_1;
E = eight_point_algorithm(m.robust_correspondences, K);
rtl = motion_estimation(m.robust_correspondences, E, K);

return;

















% Get the Key Points
Options.upright=true;  %true
Options.tresh=0.0001;
Ipts1=OpenSurf(I1, Options);
Ipts2=OpenSurf(I2, Options);

% Put the landmark descriptors in a matrix
D1 = reshape([Ipts1.descriptor], 64, []); 
D2 = reshape([Ipts2.descriptor], 64, []); 

% Find the best matches
err=zeros(1, length(Ipts1));
cor1=1:length(Ipts1); 
cor2=zeros(1, length(Ipts1));
for i=1:length(Ipts1)
  % Bias Gain Normalization
  %D1(:,i) = bias_gain_normalization(D1(:,i));
  %D2(:,i) = bias_gain_normalization(D2(:,i));
  distance=sum((D2-repmat(D1(:,i),[1 length(Ipts2)])).^2,1);
  [err(i),cor2(i)]=min(distance);
  % Avoid multiple correspondences to one feature
  D2(:,cor2(i)) = Inf(size(D2,1),1);
end
% Sort matches on vector distance
[err, ind]=sort(err);
cor1=cor1(ind); 
cor2=cor2(ind);
% Create correspondence matrix [x1;y1;x2,y2]
correspondences = [ Ipts1(cor1).x;
                    Ipts1(cor1).y;
                    Ipts2(cor2).x;
                    Ipts2(cor2).y ];
  
% Visualize correspondences
figure();
bottomImg = imshow(I1);
hold on;
alpha = 0.5.*ones(size(I2,1),size(I2,2));
set(bottomImg, 'AlphaData', alpha);
topImg = imshow(I2);
set(topImg, 'AlphaData', alpha);

plot(correspondences(1,1:300), correspondences(2,1:300), 'rs');
plot(correspondences(3,1:300), correspondences(4,1:300), 'gs');

% Show best matches
  for i=1:300   
      plot([correspondences(1,i), correspondences(3,i)], [correspondences(2,i), correspondences(4,i)],'Color','b','LineWidth',1);
  end
  
% Extract robust correspondences  
%correspondences = ransac_algorithm(correspondences(:,1:300), 'epsilon', 0.75);
correspondences = ransac_algorithm(correspondences(:,1:400), 'epsilon', 0.75, 'tolerance', 0.08);

% Visualize robust correspondences
figure();
bottomImg = imshow(I1);
hold on;
alpha = 0.5.*ones(size(I2,1),size(I2,2));
set(bottomImg, 'AlphaData', alpha);
topImg = imshow(I2);
set(topImg, 'AlphaData', alpha);

plot(correspondences(1,:), correspondences(2,:), 'rs');
plot(correspondences(3,:), correspondences(4,:), 'gs');

% Show best matches
for i=1:size(correspondences,2)
  plot([correspondences(1,i), correspondences(3,i)], [correspondences(2,i), correspondences(4,i)],'Color','b','LineWidth',1);
end

K = calibration_1;
E = eight_point_algorithm(robust_correspondences, K);
rtl = motion_estimation(robust_correspondences, E, K);
 