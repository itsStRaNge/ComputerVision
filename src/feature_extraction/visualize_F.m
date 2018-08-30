function visualize_F(I1, I2, points1, points2, F)

    figure('Name','Visualization of Fundamental Matrix F by ploting epipolar lines of tree random points.');
    subplot(1,2,1);
    imshow(rgb2gray(I1));
    hold on;
    % get 3 random sample points
    index = randsample(size(points1,2),3)';
    sample_points = points1(:,index);
    
    % plot sample points
    plot(sample_points(1,1), sample_points(2,1),'r*');
    plot(sample_points(1,2), sample_points(2,2),'g*');
    plot(sample_points(1,3), sample_points(2,3),'b*');
    
    % epipol 1
    [U, sigma, V] = svd(F);
    e1_ = V(:,3);

    % plot epipolar lines of sample_points
    l1_1 = cross(e1_, [sample_points(:,1);1]);
    drawLineFromCoimage(l1_1, I1);
    l1_2 = cross(e1_, [sample_points(:,2);1]);
    drawLineFromCoimage(l1_2, I1);
    l1_3 = cross(e1_, [sample_points(:,3);1]);
    drawLineFromCoimage(l1_3, I1);  

    subplot(1,2,2);
    imshow(rgb2gray(I2));
    hold on;
    
    l2_1 = F*[sample_points(:,1);1];
    drawLineFromCoimage(l2_1, I2);
    l2_2 = F*[sample_points(:,2);1];
    drawLineFromCoimage(l2_2, I2);
    l2_3 = F*[sample_points(:,3);1];
    drawLineFromCoimage(l2_3, I2);  
    drawnow();
    
%     % Find and draw potential correspondences    
%     points2 = [points2; ones(1,size(points2,2))];
%         
%     % epipol 2
%     [U, sigma, V] = svd(F');
%     e2_ = V(:,3);
%     
%     for i=1:size(points2,2)
%         l2_ = cross(e2_, points2(:,i));
% 
%         c = abs(norm(cross(l2_1, l2_)));
%         if c < 0.05
%             plot(points2(1,i), points2(2,i),'r*');
%             drawLineFromCoimage(l2_, I2);
%         else
%             plot(points2(1,i), points2(2,i),'ys');
%         end        
%     end
end



%plot([sample_points(1,1), e1_(1)], [sample_points(2,1), e1_(2)], 'Color', 'r', 'LineWidth', 1);
%plot([sample_points(1,2), e1_(1)], [sample_points(2,2), e1_(2)], 'Color', 'g', 'LineWidth', 1);
%plot([sample_points(1,3), e1_(1)], [sample_points(2,3), e1_(2)], 'Color', 'b', 'LineWidth', 1);