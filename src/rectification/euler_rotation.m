function rotation = euler_rotation(yaw_deg, pitch_deg, roll_deg)
    % rads = deg2rad([yaw_deg, pitch_deg, roll_deg]);
    rads = ([yaw_deg, pitch_deg, roll_deg]) * (pi/180.0);
    cos_y = cos(rads(1));
    sin_y = sin(rads(1));
    cos_p = cos(rads(2));
    sin_p = sin(rads(2));
    cos_r = cos(rads(3));
    sin_r = sin(rads(3));

    r_x = eye(3);
    r_x(2,2) = cos_r;
    r_x(3,3) = cos_r;
    r_x(2,3) = -sin_r;
    r_x(3,2) = sin_r;

    r_y = eye(3);
    r_y(1,1) = cos_p;
    r_y(3,3) = cos_p;
    r_y(1,3) = sin_p;
    r_y(3,1) = -sin_p;

    r_z = eye(3);
    r_z(1,1) = cos_y;
    r_z(2,2) = cos_y;
    r_z(1,2) = -sin_y;
    r_z(2,1) = sin_y;

    rotation = r_z * r_y * r_x;    
end