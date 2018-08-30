function test_synthesis()
%% load data
load ws_test


%outputImage1 = synthesis_one_side(disp_left,IL_resized,IR_resized,1);
outputImage2 = synthesis_both_sides(disp_left,disp_right,I1_small,I2_small,0.5);

save('synthesis.mat', 'outputImage');

%% apply synthesis for different p
for p=0:0.02:1
    % apply synthesis for one p
    outputImage = synthesis_one_side(disparity_map,IL_resized,IR_resized,p);
    imwrite(outputImage,strcat('im_',sprintf('%02d',p*50),'.jpg'));
end