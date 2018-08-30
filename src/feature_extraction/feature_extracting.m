function features = feature_extracting(I1, I2, do_plot)
    % Get the Key Points
    Options.upright=true;
    Options.tresh=0.0008;
    Ipts1=OpenSurf(rgb2gray(I1),Options);
    Ipts2=OpenSurf(rgb2gray(I2),Options);
    features.P1 = [Ipts1.x; Ipts1.y];
    features.P2 = [Ipts2.x; Ipts2.y];
    
    % Put the landmark descriptors in a matrix
    D1 = reshape([Ipts1.descriptor],64,[]); 
    D2 = reshape([Ipts2.descriptor],64,[]);
    features.D1 = D1;
    features.D2 = D2;
    
    
%     % Match features
%     matches = epipolar_feature_matching(features.points1, D1, features.points2, D2, @feature_matching);
%     features.first_matches = matches;
%     if do_plot
%         % Visualize correspondences
%         visualize_matches(I1,I2,matches,200);
%     end
%     
%     % Filter robust correspondences  
%     robust_matches = ransac_algorithm(matches(:,1:200), 'epsilon', 0.75, 'tolerance', 0.1);
%     features.robust_matches = robust_matches;
%     if do_plot
%         % Visualize robust correspondences
%         visualize_matches(I1,I2,robust_matches,200);
%     end
    
    
    
%     % Compute min and max match distance of rubust matches
%     distance = sqrt(sum((robust_matches(1:2,:) - robust_matches(3:4,:)).^2));
%     distance = sort(distance);
%     dist_range = [mean(distance(1:5))*0.9, mean(distance(length(distance)-4:length(distance)))*1.1];
%     
%     % Compute Fundamental Matrix
%     F = eight_point_algorithm(robust_matches)
%     features.F = F;
%     if do_plot
%         visualize_F(I1, I2, features.points1, features.points2, F)
%     end
%     
%     % Motion estimation
%     E = K'*F*K;
%     [R, T, lambda] = motion_estimation(robust_matches, E, K);
%     features.E = E;
%     features.R = R;
%     features.T = T;
%     
%     
%     % Match features again with given F
%     new_matches = epipolar_feature_matching(features.points1, D1, features.points2, D2, @feature_matching, F, dist_range);
%     features.correspondences = new_matches;
%     if do_plot
%         % Visualize correspondences
%         visualize_matches(I1,I2,new_matches,300);
%     end
% 
end


function visualize_matches(I1, I2, correspondences, max)
    % Visualize correspondences
    figure();
    bottomImg = imshow(I1);
    hold on;
    alpha = 0.5.*ones(size(I2,1),size(I2,2));
    set(bottomImg, 'AlphaData', alpha);
    topImg = imshow(I2);
    set(topImg, 'AlphaData', alpha);
    
    if max > size(correspondences,2)
        max = size(correspondences,2);
    end

    plot(correspondences(1,1:max), correspondences(2,1:max),'rs');
    plot(correspondences(3,1:max), correspondences(4,1:max),'g*');

    % Show first max matches
    for i=1:max
      plot([correspondences(1,i), correspondences(3,i)], [correspondences(2,i), correspondences(4,i)],'Color','b','LineWidth',1);
    end
    drawnow();
end


%https://de.mathworks.com/matlabcentral/fileexchange/28300-opensurf-including-image-warp


