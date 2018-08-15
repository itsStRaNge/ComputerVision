function seg3d = opti_avgdisp (disp,bwseg,snum)
%[rm,cm]=find(disp>0);    %rm,cm- rows and columns where disp>0. 
 zm=disp(disp>0);         %zm=z values of disparity.     
 [Lm,num] = bwlabel(bwseg); 
 
 %for ss=1:num
     sm = regionprops(Lm==snum, 'PixelList'); %sm is a structure where segment properties are stored.  
     segxm=sm.PixelList(:,1);         % x and y coordinates of segment pixels.
     segym=sm.PixelList(:,2);
      [row_img, col_img]=size(bwseg);
     seg3d=zeros(row_img, col_img);
     seg3d(sub2ind(size(seg3d),segym,segxm))=mean(zm);
 
    
  %  end
   % seg3d=zeros(480,640);
    %    seg3d(sub2ind(size(seg3d),segym,segxm))= mean(zm);
 