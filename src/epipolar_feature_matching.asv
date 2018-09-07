function matches = epipolar_feature_matching(points1, descriptors1, points2, descriptors2, matching_function, F, dist_range, I1, I2)

    if nargin == 5
        %% Call matching function
        matches = matching_function(points1, descriptors1, points2, descriptors2);
        matches_2to1 = matching_function(points2, descriptors2, points1, descriptors1);
        matches_2to1_swap = [matches_2to1(3:4,:); matches_2to1(1:2,:)];
         
        for i=1:size(matches,2)
           idx = ismember(matches_2to1_swap', matches(:,i)', 'rows');
           if nnz(idx)
               % match each other
           else
               % remove match
               matches(:,i) = zeros(4,1);
           end  
        end
       
        matches(:,any(~matches,1)) = [];
        
    else
        %% Presort potential matches according to F
        threshold = 0.01;
        matches = zeros(4, length(points1));
        
        % Transfrom points into homogeneous koordinates
        % x1_hom = [x1; 1]
        points1 = [points1; ones(1,length(points1))];
        points2 = [points2; ones(1,length(points2))];
        
        % Compute epipol e2
        % F'*e2 = 0
        [U, s, V] = svd(F');
        e2 = V(:,3);           

        % Compute epipolar lines l2 of all points based on points1
        % l2 ~ F*x1
        l2_p1 = F*points1;
        
        % Compute epipolar lines of all points2 with cross product
        % l2 ~ e2 (cross) x2
        e2_cross = [0 -e2(3) e2(2); e2(3) 0 -e2(1); -e2(2) e2(1) 0];
        l2_p2 = e2_cross*points2;
        

        for i=1:length(points1)        
            l2_p1_i = [0 -l2_p1(3,i) l2_p1(2,i); l2_p1(3,i) 0 -l2_p1(1,i); -l2_p1(2,i) l2_p1(1,i) 0];
            m = abs(sum(l2_p1_i*l2_p2));
            m(m<threshold) = 0;
            m = ~logical(m);
            
            if nnz(m) > 0
                idx = repmat(m,3,1);
                potential_points2 = reshape(points2(idx),3,nnz(m));
                idx = repmat(m,size(descriptors1,1),1);
                potential_descriptors2 = reshape(descriptors2(idx),size(descriptors1,1), nnz(m));

                % Remove points which are outside of dist_range
                point1_i_rep = repmat(points1(:,i),1,size(potential_points2,2));
                distance = sqrt(sum((point1_i_rep(1:2,:) - potential_points2(1:2,:)).^2));
                distance(distance<dist_range(1)) = 0;
                distance(distance>dist_range(2)) = 0;
                distance = logical(distance);
                if nnz(distance) == 0
                   continue; 
                end
                idx = repmat(distance,3,1);
                potential_points2 = reshape(potential_points2(idx),3,nnz(distance));
                idx = repmat(distance,size(descriptors1,1),1);
                potential_descriptors2 = reshape(potential_descriptors2(idx),size(descriptors1,1), nnz(distance));
                
                % Visualize potential matches
                if nargin == 9
                    figure(3);
                    subplot(1,2,1);
                    imshow(rgb2gray(I1));
                    hold on;
                    plot(points1(1,i), points1(2,i),'rs');
                    [U, s, V] = svd(F);
                    e1 = V(:,3);
                    l1 = cross(e1, points1(:,i));
                    drawLineFromCoimage(l1, I1);
                    subplot(1,2,2);
                    imshow(rgb2gray(I2));
                    hold on;
                    drawLineFromCoimage(l2_p1(:,i), I2);
                    for j=1:size(potential_points2,2)
                        plot(potential_points2(1,j), potential_points2(2,j),'r*');
                    end
                end
                
                matches(:,i) = matching_function(points1(1:2,i), descriptors1(:,i), potential_points2(1:2,:), potential_descriptors2);
                
                % Visualize match
                if nargin == 9
                    subplot(1,2,2);
                    plot(matches(3,i), matches(4,i),'gs');
                    pause(1);
                end
            end
        end
            
    end
end


%    else               
%         %% Match descriptors
%         err = zeros(1,size(points1,2));
%         cor1 = 1:size(points1,2);
%         cor2 = zeros(1,size(points1,2));
%         
%         for i=1:size(points1,2)
%           % SSD metric
%           d1_rep = repmat(descriptors1(:,i),[1 size(points2,2)]);
%           distance = sum((descriptors2-d1_rep).^2,1);
%           [err(i), cor2(i)] = min(distance);
%           % Avoid multiple matches
%           %descriptors2(:,cor2(i)) = Inf(size(descriptors2,1),1);
%         end
% 
%         % Sort matches on vector distance
%         [err, ind] = sort(err);
%         cor1 = cor1(ind); 
%         cor2 = cor2(ind);
% 
%         % Create correspondence matrix [x1;y1;x2,y2]
%         matches = [ points1(:,cor1);
%                     points2(:,cor2)];
    