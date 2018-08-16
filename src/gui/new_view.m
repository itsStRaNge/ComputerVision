function output_image = new_view(disparity_map, IL, IR, Homography, p)
%% synthesis
IM = synthesis(disparity_map, IL, IR, p);

%% derectification
output_image = cv_inv_rectify(IM, Homography);
end