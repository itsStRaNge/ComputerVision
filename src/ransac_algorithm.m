function robust_correspondences = ransac_algorithm(correspondences, varargin)
    check_epsilon = @(x) isnumeric(x) && x>0 && x<1;
    check_p =  @(x) isnumeric(x) && x>0 && x<1;
    check_tolerance = @(x) isnumeric(x);

    p = inputParser;
    addRequired(p,'correspondences');
    addOptional(p,'epsilon',0.5, check_epsilon);
    addOptional(p,'tolerance',0.01, check_tolerance);
    addOptional(p,'p',0.5, check_p);
    parse(p,correspondences,varargin{:});
    
    epsilon = p.Results.epsilon;
    tolerance = p.Results.tolerance;
    p = p.Results.p;
    
    x1_pixel = [correspondences(1:2,:); ones(1,size(correspondences,2))];
    x2_pixel = [correspondences(3:4,:); ones(1,size(correspondences,2))];

    k = 8;
    s = log(1-p)/log(1-(1-epsilon)^k);
    largest_set_size = 0;
    largest_set_dist = Inf;
    
    for i=1:s
       % Select k random samples
       indices = randi(size(correspondences,2),1,k);
       samples = correspondences(:,indices);
       
       % estimate F based on selected samples
       set_F = eight_point_algorithm(samples);
       
       % compute the sampson distance for all data
       set_dist = sampson_dist(set_F, x1_pixel, x2_pixel);
       
       % compute set_size
       set_size = nnz(set_dist<tolerance);
       
       if set_size > largest_set_size
           largest_set_size = set_size;
           largest_set_dist = set_dist;
       end
    end

    indices = largest_set_dist<tolerance;
    robust_correspondences = correspondences(:,indices);
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