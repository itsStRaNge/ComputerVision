function seg3d = opti_segtinterp (disp,bwseg,snum)
%the function takes disparity points and  segment as input and gives it depth representation in mesh form.
%converts to Mesh.
 [rm,cm]=find(disp>0);    %rm,cm- rows and columns where disp>0. 
 zm=disp(disp>0);         %zm=z values of disparity.     
 [Lm,num] = bwlabel(bwseg); %in cases where single segments are combined.
%for ss=1:num
     sm = regionprops(Lm==snum, 'PixelList'); %sm is a structure where segment properties are stored.  
     segxm=sm.PixelList(:,1);         % x and y coordinates of segment pixels.
     segym=sm.PixelList(:,2);
     % if(cm~=0)             % griddata function gives error for empty regions.hence do not interpolate on empy regions. 
     p =[rm,cm];
     t = delaunayn(p);
     f = zm;
     xi= segxm;
     yi=  segym;
        
     fi = tinterp(p,t,f,xi,yi,'quadratic');
     mm=nanmean(fi);
  
     if(isnan(mm))
           for i=1:length(fi)         %if whole segment is NAN then consider avg disparity .
           fi(i)=mean(f);
           end
     end
     
     for i=1:length(fi)
       if(isnan(fi(i))||fi(i)<0)
         fi(i)=mean(zm);     % truncating znew values. Dont let it be more than maximum disparity value.
       end
     end
     
     
     limit=nanmean(fi)+10;
     
     for tr=1:length(fi)
     
         if(fi(tr)>limit)
         fi(tr)=mean(zm);
         end
     end
     
     [row_img, col_img]=size(bwseg);
        seg3d=zeros(row_img, col_img);
        seg3d(sub2ind(size(seg3d),yi,xi))=fi;     
     
   %  end
%       end
     
       
  