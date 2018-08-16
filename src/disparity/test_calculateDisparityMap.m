IL=imread('officeL.png');
IR=imread('officeR.png');
dispMap=calculateDisparityMap(IL,IR,'block',800);