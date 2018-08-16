function test_synthesis()
leftrgb=imread('bikeL.png');
rightrgb=imread('bikeR.png');
load disp_bike.mat;


v=VideoWriter('test_sequence.avi');
open(v);
for p=0:0.02:1
    writeVideo(v,synthesis(disp_bike,leftrgb,rightrgb,p));
end
close(v);
end