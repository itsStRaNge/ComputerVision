function [Im_rect1,Im_rect2,H1,H2, status]= rectify_trondheim(im1,im2, F, Corr)
 
epi = Epipolar( im1, im2, F, Corr(1:2,:), Corr(3:4,:));

status = false;
% find initial rectification matrices
H1 = [   1                              0       0;...
        -epi.eP1(2)/epi.eP1(1)  1       0;...
        -1/epi.eP1(1)               0       1];

% use whole F (overconstrained) to calculate H2 for less distortion
A = [   -1             0            0       0            0            0;...
        0              -1           0       0            0            0;...
        0              0           -1       0            0            0;...
        0              0            0       1            0            0;...
        0              0            0       0            1            0;...
        0              0            0       0            0            1;...
        -H1(3,1)   0            0       H1(2,1)  0            0;...
        0              -H1(3,1) 0       0            H1(2,1)  0;...
        0               0      -H1(3,1) 0            0             H1(2,1)];
b = [   epi.F(1,3);...
        epi.F(2,3);...
        epi.F(3,3);...
        epi.F(1,2);...
        epi.F(2,2);...
        epi.F(3,2);...
        epi.F(1,1);...
        epi.F(2,1);...
        epi.F(3,1)];
x = (A'*A)\(A'*b);% least square

H2 = [  1       0   0;...
            x(1:3)';...
            x(4:6)'];

% use Jacobian of corners to minimize distortion
[r,c,~] = size( im1 );
pts = [ 0 0 1;...
        r 0 1;...
        0 c 1;...
        r c 1];
H1 = minimizeDistortion( H1, pts, 0 );
[r,c,~] = size( im2 );
pts = [ 0 0 1;...
        r 0 1;...
        0 c 1;...
        r c 1];
H2 = minimizeDistortion( H2, pts, 0 );


[rectIm1, rectIm2] = rectifyImages( im1, im2, H1, H2 );

if ~isempty( rectIm1 ) && ~isempty( rectIm2 )
    status = true;

    % transform inliers
    in1 = [epi.in1'; ones( 1,length(epi.in1)) ];  
    in2 = [epi.in2'; ones( 1,length(epi.in2)) ]; 
    in1 = (H1*in1)';
    in1 = in1./repmat( in1(:,3), 1,3);
    in2 = (H2*in2)';
    in2 = in2./repmat( in2(:,3), 1,3);
    Im_rect1=rectIm1;
    Im_rect2=rectIm2;
else
    Im_rect1 = 0;
    Im_rect2 = 0;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [im1, im2] = rectifyImages( I1, I2, H1, H2 )
    % find common transformed area
    [r1,c1,~] = size(I1);
    corners1 = transformCorners( H1, r1,c1 );
    [r2,c2,~] = size(I2);
    corners2 = transformCorners( H2, r2,c2 );
    
    corners = [ corners1;corners2 ];
    x = sort( corners(:,1) );
    y = sort( corners(:,2) );
    
    xmin = ceil( x(4) );
    xmax = floor( x(5) );
    ymin = ceil( y(4) );
    ymax = floor( y(5) );
    
    width = xmax-xmin;
    height = ymax-ymin;
    
    % check dimension
    wCond = mean([c1 c2])*0.1;
    hCond = mean([r1 r2])*0.1;
    
    if width<wCond || height<hCond% new images will be <10% of originals
         disp('Bad rectification');
         im1 = [];
         im2 = [];
         return;
    end
    
    xLim = [ xmin-0.5,xmax+0.5 ];
    yLim = [ ymin-0.5,ymax+0.5 ];
    
    tform1 = projective2d( H1' );
    tform2 = projective2d( H2' );
    
    outputView = imref2d([height-1, width-1], xLim, yLim);

    im1 = imwarp(I1, tform1, 'OutputView', outputView );
    im2 = imwarp(I2, tform2, 'Outputview', outputView );
end

function corners = transformCorners( H,r,c )
    
    a = [ [1 1 1]', [c 1 1]', [c r 1]', [1 r 1]' ];   
    a = H*a;
    a = a./repmat(a(3,:),3,1);
    
    corners = [ a(1:2,1)';a(1:2,2)';a(1:2,3)';a(1:2,4)';];% start upper left CCW around
end
end