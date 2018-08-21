function test_synthesis()
%% load data
load('disparity', 'IL_resized');
load('disparity', 'IR_resized');
load('disparity', 'disparity_map');

v=VideoWriter('test_sequence.avi');
open(v);

outputImage = synthesis(disparity_map,IL_resized,IR_resized,0.5);
save('synthesis.mat', 'outputImage');

%% apply synthesis for different p
for p=0:0.02:1
    % apply synthesis for one p
    outputImage = synthesis(disparity_map,IL_resized,IR_resized,p);
    writeVideo(v,outputImage);
end
close(v);
end