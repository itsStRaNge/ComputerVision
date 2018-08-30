function matches = feature_matching(points1, descriptors1, points2, descriptors2)
        % Match descriptors
        err = zeros(1,size(points1,2));
        cor1 = 1:size(points1,2);
        cor2 = zeros(1,size(points1,2));
        
        for i=1:size(points1,2)
          % SSD metric
          d1_rep = repmat(descriptors1(:,i),[1 size(points2,2)]);
          distance = sum((descriptors2-d1_rep).^2,1);
          [err(i), cor2(i)] = min(distance);
          % Avoid multiple matches
          descriptors2(:,cor2(i)) = Inf(size(descriptors2,1),1);
        end

        % Sort matches on vector distance
        [err, ind] = sort(err);
        cor1 = cor1(ind); 
        cor2 = cor2(ind);

        % Create correspondence matrix [x1;y1;x2,y2]
        matches = [ points1(:,cor1);
                    points2(:,cor2)];
end


%     % Find the best matches
%     err=zeros(1,length(Ipts1));
%     cor1=1:length(Ipts1); 
%     cor2=zeros(1,length(Ipts1));
%     for i=1:length(Ipts1)
%       % Bias Gain Normalization
%       %D1(:,i) = bias_gain_normalization(D1(:,i));
%       %D2(:,i) = bias_gain_normalization(D2(:,i));
%       distance=sum((D2-repmat(D1(:,i),[1 length(Ipts2)])).^2,1);
%       [err(i),cor2(i)]=min(distance);
%       % Avoid multiple matches to one feature
%       D2(:,cor2(i)) = Inf(size(D2,1),1);
%     end
%     
%     % Sort matches on vector distance
%     [err, ind]=sort(err);
%     cor1=cor1(ind); 
%     cor2=cor2(ind);
%     
%     % Create correspondence matrix [x1;y1;x2,y2]
%     correspondences = [ Ipts1(cor1).x;
%                         Ipts1(cor1).y;
%                         Ipts2(cor2).x;
%                         Ipts2(cor2).y ];
