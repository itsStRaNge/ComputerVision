function [F,robust_matches] = ransac_alternative(correspondences)
    
    x1_pixel = [correspondences(1:2,:); ones(1,size(correspondences,2))];
    x2_pixel = [correspondences(3:4,:); ones(1,size(correspondences,2))];
    
    
    min_sampson=100000;
    best_index=[];
    F=[];
    for i=1:100000
       
       indices=randperm(size(correspondences,2),8);
       
       
       % Select k random samples
       samples = correspondences(:,indices);
       
       % estimate F based on selected samples
       set_F = eight_point_algorithm(samples);
       
       % compute the sampson distance for all data
       set_dist = sampson_dist(set_F, x1_pixel, x2_pixel);
       
       
       if mean(set_dist)<min_sampson
           min_sampson=mean(set_dist);
           F=set_F;
           best_index=indices;
       end
    end
    robust_matches=correspondences(:,best_index);
end


function sd = sampson_dist(F, x1_pixel, x2_pixel)
    % Fundamental matrix F
    e3_cross = [0 -1 0; 1 0 0; 0 0 0];
    n1 = e3_cross*F*x1_pixel;
    n2 = (x2_pixel'*F*e3_cross)';
    naenner = colnorm(n1).^2+colnorm(n2).^2;
    zaehler = diag((x2_pixel'*F*x1_pixel).^2)';
    sd = zaehler./naenner;
    
    function norm = colnorm(A)
        norm = sqrt(sum(A.^2));
    end
 end