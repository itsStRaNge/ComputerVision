function visualize_matches(I1, I2, matches, max)
    % Visualize correspondences
    figure();
    bottomImg = imshow(I1);
    hold on;
    alpha = 0.5.*ones(size(I2,1),size(I2,2));
    set(bottomImg, 'AlphaData', alpha);
    topImg = imshow(I2);
    set(topImg, 'AlphaData', alpha);
    
    if max > size(matches,2)
        max = size(matches,2);
    end

    plot(matches(1,1:max), matches(2,1:max),'rs');
    plot(matches(3,1:max), matches(4,1:max),'g*');

    % Show first max matches
    for i=1:max
      plot([matches(1,i), matches(3,i)], [matches(2,i), matches(4,i)],'Color','b','LineWidth',1);
    end
    drawnow();
end