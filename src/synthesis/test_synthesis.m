function test_synthesis()
%% load data

load disparity_bike.mat
disp_left=imresize(disp_left,0.5);
disp_left=disp_left*0.5;

disp_right=imresize(disp_right,0.5);
disp_right=disp_right*0.5;

JL=imresize(JL,0.5);
JR=imresize(JR,0.5);


v=VideoWriter('sequence_civi.avi');

open(v);
counter=1;
%% apply synthesis for different p
for p=0:0.02:1
    % apply synthesis for one p
    out=strcat('synthesizing image ',num2str(counter))
    
    outputImage = synthesis_both_sides(disp_left,disp_right,JL,JR,p);
    imwrite(outputImage,strcat('im_',sprintf('%03d',counter),'.jpg'));
    writeVideo(v,outputImage);
    counter=counter+1;
end
close(v);


