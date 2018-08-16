function test_synthesis()
%% load data
leftrgb=imread('data/bikeL.png');
rightrgb=imread('data/bikeR.png');
load('data/disp_bike.mat');

v=VideoWriter('test_sequence.avi');
open(v);

%% apply synthesis for different p
for p=0:0.02:1
    % apply synthesis for one p
    outputImage = synthesis(disp_map,leftrgb,rightrgb,p);
    writeVideo(v,outputImage);
end
close(v);
end