function [R, T] = motion_estimation(correspondences, E, K)
    %% code from computer vision homework

    %% Preprocessing
    N = size(correspondences,2);
    x1_ = [correspondences(1:2,:); ones(1,N)];
    x2_ = [correspondences(3:4,:); ones(1,N)];
    x1 = K\x1_;
    x2 = K\x2_;

    d_cell = {zeros(N,2),zeros(N,2), zeros(N,2),zeros(N,2)};   
     
    %% Compute all possible R,T pairs
    [U, sigma, V] = svd(E);

    d = [1 0 0; 0 1 0; 0 0 -1];
    if det(U) < 0
        U = U*d;
    end
    if det(V) < 0
        V = V*d;
    end
    
    Rz = [0 -1 0; 1 0 0; 0 0 1];
    R1 = U*Rz'*V';
    T1_dach = U*Rz*sigma*U';
    T1 = [T1_dach(3,2); T1_dach(1,3); T1_dach(2,1)];
    
    Rz = [0 1 0; -1 0 0; 0 0 1];
    R2 = U*Rz'*V';
    T2_dach = U*Rz*sigma*U';
    T2 = [T2_dach(3,2); T2_dach(1,3); T2_dach(2,1)];

    R_cell = {R1,R1,R2,R2};
    T_cell = {T1,T2,T1,T2};
    
    %% Determine R,T pair with positive lambda
    M1 = zeros(3*N,N+1);
    M2 = M1;
    R = 0;
    T = 0;
    % lambda = 0;
    
    for j=1:4      
        for i=1:N
            s = (i-1)*3+1;
            M1(s:s+2,i) = cross(x2(:,i), R_cell{j}*x1(:,i));
            M1(s:s+2,N+1) = cross(x2(:,i), T_cell{j});
            M2(s:s+2,i) = cross(x1(:,i), R_cell{j}'*x2(:,i));
            M2(s:s+2,N+1) = -cross(x1(:,i), R_cell{j}'*T_cell{j});
            
            %M1(s:s+2,i) = dach(x2(:,i))*R_cell{j}*x1(:,i);
            %M1(s:s+2,N+1) = dach(x2(:,i))*T_cell{j};
            %M2(s:s+2,i) = dach(x1(:,i))*R_cell{j}'*x2(:,i);
            %M2(s:s+2,N+1) = -dach(x1(:,i))*R_cell{j}'*T_cell{j};
        end
        
        % solve Md=0
        [U,sig,V] = svd(M1);
        d1 = V(:,N+1);
        d1 = d1./d1(N+1);
        
        [U,sig,V] = svd(M2);
        d2 = V(:,N+1);
        d2 = d2./d2(N+1);
      
        d_cell{j} = [d1(1:N) d2(1:N)];
  
        d1(d1(:)>0) = 0;
        d2(d2(:)>0) = 0;
        
        if(nnz(d1)==0 && nnz(d2)==0)
            R = R_cell{j};
            T = T_cell{j};
            % lambda = d_cell{j};
            break;
        end  
    end
end