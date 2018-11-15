# ComputerVision Challenge
This project is part of the course Computer Vision at the Technical University Munich. It is about creating a image that 
shows a sceen between a stereo image pair. Patrick von Velasco, Alexander Lechthaler, Lukas Bernhard, Thomas Hartmann contributed to 
this project and a german and more detailed documentation can be found at [Computer Vision Challenge Group 37.pdf](https://github.com/itsStRaNge/ComputerVision/blob/master/Computer%20Vision%20Challenge%20Group%2037.pdf "Documentation").

## Procedure
**Input**

As input a stereo image pair, a parameter p that defines the angle for the output image and a camera callibration matrix K is needed

**Steps**

1. Lense Undistortion
2. Feature Extraction
3. Feature Matching
4. Calculation of Eucledian Movement
5. Image Rectification
6. Depth Map Calculation
7. Synthesis
8. Derectification

**Output**

Synthesised image 

## Examples
Complete run through the algorithm

![Alt text](/output/testset%202/000.JPG "Left part of stereo image pair")
Left part of stereo image pair

![Alt text](/output/testset%202/050.png "Angle between input images")
Angle between input images

![Alt text](/output/testset%202/100.JPG "Right part of stereo image pair")
Right part of stereo image pair

### Displaying Synthesis Algorithm Only


![Alt text](/output/bike/im_001.jpg "Left part of stereo image pair")
Left part of stereo image pair

![Alt text](/output/bike/im_025.jpg "Angle between input images")
Angle between input images

![Alt text](/output/bike/im_051.jpg "Right part of stereo image pair")
Right part of stereo image pair
