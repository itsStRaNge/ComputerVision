function test_synthesis()
%% load data

load disparity_teddy.mat

%disp_left =disp_left/2;
%disp_right=disp_right/2;
%disp_left =imresize(disp_left,0.5);
%disp_right=imresize(disp_right,0.5);
%JL=imresize(JL,0.5);
%JR=imresize(JR,0.5);


%{
preprocessing for fake disp map, ignore if not used
disp_left=rgb2gray(imread('disp_hand_l.png'));
disp_left=double(disp_left);
disp_left=1./disp_left;

%%-120 - 450
disp_left = (disp_left - min(disp_left(:))) * (450 - (-120)) / (max(disp_left(:)) - min(disp_left(:))) -120;
disp_left = -disp_left;

JL=imread('im_hand_l.png');
JR=imread('im_hand_r.png');
%}


%v=VideoWriter('sequence_civi.avi');

%outputImage1 = synthesis_one_side(disp_left,IL_resized,IR_resized,1);
%tic
%outputImage = synthesis_both_sides(disp_left,disp_right,JL,JR,0.5);
%toc

open(v);
counter=1;
%% apply synthesis for different p
for p=0:0.02:1
    % apply synthesis for one p
    outputImage = synthesis_both_sides(disp_left,disp_right,JL,JR,p);
    imwrite(outputImage,strcat('im_',sprintf('%03d',counter),'.jpg'));
    writeVideo(v,outputImage);
    counter=counter+1;
end
close(v);


