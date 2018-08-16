function features = surf_extracting_matching(I1, I2, do_plot)
    % features = {points1, points2, correspondences}

    % Get the Key Points
    Options.upright=true;
    Options.tresh=0.0001;
    Ipts1=OpenSurf(I1,Options);
    Ipts2=OpenSurf(I2,Options);
    
    features.points1 = [Ipts1.x; Ipts1.y];
    features.points2 = [Ipts2.x; Ipts2.y];

    % Put the landmark descriptors in a matrix
    D1 = reshape([Ipts1.descriptor],64,[]); 
    D2 = reshape([Ipts2.descriptor],64,[]); 

    % Find the best matches
    err=zeros(1,length(Ipts1));
    cor1=1:length(Ipts1); 
    cor2=zeros(1,length(Ipts1));
    for i=1:length(Ipts1)
      % Bias Gain Normalization
      %D1(:,i) = bias_gain_normalization(D1(:,i));
      %D2(:,i) = bias_gain_normalization(D2(:,i));
      distance=sum((D2-repmat(D1(:,i),[1 length(Ipts2)])).^2,1);
      [err(i),cor2(i)]=min(distance);
      % Avoid multiple matches to one feature
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
    features.correspondences = correspondences;

    % Visualize correspondences
    if do_plot
        visualize_correspondences(I1,I2,correspondences,300);
    end
    
    % Extract robust correspondences  
    correspondences = ransac_algorithm(correspondences(:,1:400), 'epsilon', 0.75, 'tolerance', 0.08);
    features.robust_correspondences = correspondences;

    % Visualize robust correspondences
    if do_plot
        visualize_correspondences(I1,I2,correspondences,300);
    end
end


function visualize_correspondences(I1, I2, correspondences, max)
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
    plot(correspondences(3,1:max), correspondences(4,1:max),'gs');

    % Show first max matches
    for i=1:max
      plot([correspondences(1,i), correspondences(3,i)], [correspondences(2,i), correspondences(4,i)],'Color','b','LineWidth',1);
    end
end



