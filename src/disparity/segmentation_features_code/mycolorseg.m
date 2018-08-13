function [leftcolorseg,rightcolorseg]=mycolorseg(left,right,left_seg,right_seg)
% Function Format:
% [leftcolorseg,rightcolorseg]=mycolorseg(left,right,left_seg,right_seg)
% The function inputs are left,right-left&right grayscale images.
%  left_seg,right_seg binary segments 
[row_img, col_img]=size(left_seg);

leftcolorseg=zeros(row_img, col_img);
leftcolorseg(find(left_seg>0))=left(find(left_seg>0));
leftcolorseg=uint8(leftcolorseg);

rightcolorseg=zeros(row_img, col_img);
rightcolorseg(find(right_seg>0))=right(find(right_seg>0));
rightcolorseg=uint8(rightcolorseg);