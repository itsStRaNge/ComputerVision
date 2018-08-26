function output_image = new_view(disparity_map, IL, IR, Homography, p, console)
%% synthesis
print_console(console, 'Synthesising New Image');
IM = synthesis(disparity_map, IL, IR, p);

%% derectification
print_console(console, 'Derectificating New Image');
output_image = cv_inv_rectify(IM, Homography);
end