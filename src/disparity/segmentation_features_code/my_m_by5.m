function m1= my_m_by5(left,right,leftcolorseg,rightcolorseg)
[row_img, col_img]=size((left));

%%%left image segment%%%
[r_leftcolor_seg,c_leftcolor_seg]=find(leftcolorseg>0);
d_leftcolor_seg=[c_leftcolor_seg,r_leftcolor_seg];
ytr_left=SURFPoints(d_leftcolor_seg);

%%%right image segment%%%

[r_rightcolor_seg,c_rightcolor_seg]=find(rightcolorseg>0);
d_rightcolor_seg=[c_rightcolor_seg,r_rightcolor_seg];
ytr_right=SURFPoints(d_rightcolor_seg);

%   ytr_points_left=ytr_left.Location;
%   ytr_points_right=ytr_right.Location;

ytr_points_left_temp=ytr_left.Location;
ytr_points_right_temp=ytr_right.Location;

inspect_index_l = 1:10:length(ytr_points_left_temp)';
inspect_index_r = 1:10:length(ytr_points_right_temp)';

if(length(inspect_index_l)>=length(inspect_index_r))
    sampled_indices=inspect_index_r';
end

if(length(inspect_index_l)<length(inspect_index_r))
    sampled_indices=inspect_index_l';
end

ytr_points_left=ytr_points_left_temp(sampled_indices,:);
ytr_points_right=ytr_points_right_temp(sampled_indices,:);

 
 [segFeatures_left,segpoints_left] = extractFeatures(left, ytr_points_left);
 [segFeatures_right,segpoints_right] = extractFeatures(right, ytr_points_right); 
 
 indexPairs_SURF = matchFeatures(segFeatures_left, segFeatures_right);
 
 cord_left=segpoints_left(indexPairs_SURF(:,1),:);
 cord_right=segpoints_right(indexPairs_SURF(:,2),:);

 index=find(abs(((cord_left(:,2)-cord_right(:,2))))<1);
 cord_left1=cord_left(index,:);
 cord_right1=cord_right(index,:);

  m1=zeros(row_img, col_img);
  m1(sub2ind(size(m1),floor(cord_left1(:,2)),floor(cord_left1(:,1))))=abs(cord_left1(:,1)-cord_right1(:,1));
 
 
 
 %figure,showMatchedFeatures(leftcolorseg,rightcolorseg,cord_left1,cord_right1,'PlotOptions',{'ro','go','y'});
 
 %figure; showMatchedFeatures(leftcolorseg,rightcolorseg,cord_left1,cord_right1,'montage');