function test_synthesis()
%% load data
load disparity.mat


v=VideoWriter('sequence_civi.avi');

%outputImage1 = synthesis_one_side(disp_left,IL_resized,IR_resized,1);
%outputImage = synthesis_both_sides(disp_left,disp_right,JL,JR,0.5);

open(v);
counter=1;
%% apply synthesis for different p
for p=0:0.05:1
    % apply synthesis for one p
    outputImage = synthesis_both_sides(disp_left,disp_right,JL,JR,p);
    imwrite(outputImage,strcat('im_',sprintf('%03d',counter),'.jpg'));
    writeVideo(v,outputImage);
    counter=counter+1;
end
close(v);

