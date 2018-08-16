function test_synthesis()
%% load data
leftrgb=imread('data/hatsL.png');
rightrgb=imread('data/hatsR.png');
load('data/disp_hats.mat', 'disp_map');
v=VideoWriter('data/output_test_seq.avi');
open(v);

%% apply synthesis for different p
for p=0:0.02:1
    % apply synthesis for one p
    outputImage = synthesis(disp_map,leftrgb,rightrgb,p);
    writeVideo(v,outputImage);
end
close(v);
end