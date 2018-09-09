function EF = eight_point_algorithm(correspondences, K)    
    % Convert to homogen coordinates
    onesRow = ones(1,size(correspondences,2));
    x1 = [correspondences(1:2,:); onesRow];
    x2 = [correspondences(3:4,:); onesRow];
    
    % Calibrate coordinates if K given
    if nargin == 2
        x1 = K\x1;
        x2 = K\x2;
    end
    
    % Create linear equation system
    A = zeros(size(correspondences,2),9);
    for i=1:size(correspondences,2)
        A(i,:) = kron(x1(:,i),x2(:,i))';
    end
    
    [U,sigma,V] = svd(A);
    
    % Essential Matix
    Gs = V(:,9);
    G = reshape(Gs,[3,3]);
    [Ug, sigma, Vg] = svd(G);
    sigma(3,3) = 0;
 
    if nargin == 2
        % Estimate Essential Matrix E
        EF = Ug*[1 0 0; 0 1 0; 0 0 0]*Vg';
    else
        % Estimate Fundamental Matrix F
        EF = Ug*sigma*Vg';
    end
    
    
end