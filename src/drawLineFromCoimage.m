function drawLineFromCoimage(l,Image)

X1=0;
X2=size(Image,2);

Y1 = -l(3)/l(2);
Y2 = -(X2*l(1)+l(3))/l(2);

line([X1;X2],[Y1;Y2])

end