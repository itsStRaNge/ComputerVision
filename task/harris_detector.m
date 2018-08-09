
function features = harris_detector(input_image, varargin)
    %% Input parser
    check_segment_length = @(x) isnumeric(x) && x>1 && (mod(x,2)==1);
    check_k = @(x) isnumeric(x) && x>=0 && x<=1;
    check_tau = @(x) isnumeric(x) && x>0;
    check_min_dist = @(x) isnumeric(x) && x>=1;
    check_tile_size = @(x) isnumeric(x);
    check_N = @(x) isnumeric(x) && x>=1;
    check_do_plot = @(x) islogical(x);
    
    p = inputParser;
    addRequired(p,'input_image');
    addOptional(p,'segment_length',15, check_segment_length);
    addOptional(p,'k',0.05, check_k);
    addOptional(p,'tau',10^6, check_tau);
    addOptional(p,'min_dist', 20, check_min_dist);
    addOptional(p,'tile_size',[200 200], check_tile_size);
    addOptional(p,'N',5, check_N);
    addOptional(p,'do_plot', false, check_do_plot);
    parse(p,input_image,varargin{:});
    
    segment_length = p.Results.segment_length;
    k = p.Results.k;
    tau = p.Results.tau;
    min_dist = p.Results.min_dist;
    if size(p.Results.tile_size,2) == 1
       tile_size = [p.Results.tile_size, p.Results.tile_size];
    else
       tile_size = p.Results.tile_size;
    end
    N = p.Results.N;
    do_plot = p.Results.do_plot;
    

    %% Preprocessing steps
    % Convert image to grayscale
    if size(input_image,3) == 3
        %red = double(input_image(:, :, 1));
        %green = double(input_image(:, :, 2));
        %blue = double(input_image(:, :, 3));
        %input_image = double(0.299*red + 0.587*green + 0.114*blue);
        input_image = rgb2gray(input_image);
    else
        % Convert image to double
        input_image = double(input_image); 
    end
    
    % Compute image gradient    
    sobel_horizontal = [1, 0, -1; 2, 0, -2; 1, 0, -1];
    sobel_vertical = sobel_horizontal';
    Ix = conv2(input_image, sobel_horizontal, 'same');
    Iy = conv2(input_image, sobel_vertical, 'same');
    
    % Compute pixel weigth matrix
    w = fspecial('gaussian', [1 segment_length], segment_length);
    W = w'*w;
    
    %% Compute Harris Matrix G = [G11, G12; G12, G22]
    G11 = conv2(Ix.*Ix, W, 'same');
    G12 = conv2(Ix.*Iy,W,'same');
    G22 = conv2(Iy.*Iy, W,'same');
    H_corners = G11.*G22 - G12.^2 - k*(G11 + G22).^2;
    
    H_corners(1:ceil(segment_length/2), :) = 0;
    H_corners(:, 1:ceil(segment_length/2)) = 0;
    H_corners(:, end-ceil(segment_length/2):end) = 0;
    H_corners(end-ceil(segment_length/2):end, :) = 0;
    H_corners(abs(H_corners)<tau) = 0;
    
    % Add min_dist 0 border to corners matrix
    z11 = zeros(min_dist, min_dist);
    z12 = zeros(min_dist, size(H_corners,2));
    z21 = zeros(size(H_corners,1), min_dist);
    H_corners = [z11, z12, z11;
                 z21, H_corners, z21;
                 z11, z12, z11];

    %% Extract features form harris meassure matrix
    % Sort harris meassure matrix entries and remove zeros
    [i, sorted_index] = sort(H_corners(:), 'descend');
    sorted_index(H_corners(sorted_index)==0) = [];
    
    % Akkumulator matrix for feature count in segments
    [r, c] = size(input_image);
    AKKA = zeros(ceil(r/tile_size(1)), ceil(c/tile_size(2)));
    
    if(N*numel(AKKA) > size(sorted_index,1))
        features = zeros(2, size(sorted_index,1));
    else
        features = zeros(2, N*numel(AKKA));
    end
    
    % Cake filter for min distance between features
    mat_size = 2*min_dist+1;
    center = (mat_size+1)/2;
    filter = false(mat_size);
    for r=1:size(filter,1)
        for c=1:size(filter,2)
            if sqrt((center-r)^2+(center-c)^2) <= min_dist
                filter(r,c) = 0;
            else
                filter(r,c) = 1;
            end 
        end
    end
    
    %% Determine best features within segments
    for i=1:size(sorted_index)
        % Check if featuer still exists
        if H_corners(sorted_index(i)) == 0
            continue;
        end
        
        % Determine catresian coordinates
        [rf_index, cf_index] = ind2sub(size(H_corners), sorted_index(i));
        % Determine segment coordinates
        rk_index = ceil((rf_index-min_dist)/tile_size(1));
        ck_index = ceil((cf_index-min_dist)/tile_size(2)); 
        
        if AKKA(rk_index, ck_index) < N
            AKKA(rk_index, ck_index) = AKKA(rk_index, ck_index) + 1;
            features(:,i) = [cf_index-min_dist; rf_index-min_dist];
            % Remove close neighbours
            ri_min = rf_index-min_dist;
            ri_max = rf_index+min_dist;
            ci_min = cf_index-min_dist;
            ci_max = cf_index+min_dist;
            H_corners(ri_min:ri_max, ci_min:ci_max) = H_corners(ri_min:ri_max, ci_min:ci_max).*filter;
        else
            H_corners(sorted_index(i)) = 0;
        end
    end
    
    %% Plot Harris features
    if do_plot
        imshow(input_image);
        hold on;
        plot(features(1,:), features(2,:),'r*');
        
        % Plot horizontal segment borders
        c = 1;
        r = tile_size(1);
        while r<size(input_image,1)
                plot([c, size(input_image,2)], [r, r],'Color','g','LineWidth',0.1);
                r = r+tile_size(1);
        end
        % Plot vertical segment borders
        c = tile_size(2);
        r = 1
        while c<size(input_image,2)
                plot([c, c], [r, size(input_image,1)],'Color','g','LineWidth',0.1);
                c = c+tile_size(2);
        end
    end
    
end

% features = harris_detector(gray, 'segment_length', 9, 'k', 0.06, 'do_plot', true);
