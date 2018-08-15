function test_synthesis()
leftrgb=imread('hatsL.png');
rightrgb=imread('hatsR.png');
load disp_hats.mat disp_map;

v=VideoWriter('test_sequence.avi');
open(v);
for p=0:0.02:1
    writeVideo(v,synthesis(disp_map,leftrgb,rightrgb,p));
end
close(v);
end