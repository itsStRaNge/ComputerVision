function filld = opti_fill2( out_image,row_img,col_img )

  se = strel('disk',1); %Create a disk-shaped structuring element with a radiusof 1 pixels.Remove areas having a radius less than 1 pixels 
  imf=imclose(out_image,se);
  filld=imfill(imf,'holes');
  figure,imshow(uint8(filld));

  
  
colf=0;
for rowf=1:row_img
     if(filld(rowf,1)==0)
       
         for colf=1:col_img
        
             if(filld(rowf,colf)~=0) 
                 for zf=1:colf
                     
               filld(rowf,zf)=filld(rowf,colf);
                                 end
                  break
             end
         end
     end
end


colf=col_img;
for rowf=1:row_img
     if(filld(rowf,col_img)==0)
       
         for colf=col_img:-1:1
        
              if(filld(rowf,colf)~=0) 
                 for zf=colf:1:col_img
                     
               filld(rowf,zf)=filld(rowf,colf);
                
                 end
                  break
             end
         end
     end
end

rowf=0;
for colf=1:col_img
     if(filld(1,colf)==0)
       
         for rowf=1:row_img
        
             if(filld(rowf,colf)~=0)     
                 for xf=rowf:-1:1
             filld(xf,colf)=filld(rowf,colf);
              
                 end
              break
             end
         end
     end
end



rowf=row_img;
for colf=col_img:-1:1
     if(filld(row_img,colf)==0)
     
         for rowf=row_img:-1:1
     
             if(filld(rowf,colf)~=0)     
                 for xf=rowf:1:row_img
             filld(xf,colf)=filld(rowf,colf);
              
                 end
              break
             end
         end
     end
end
       filld=imfill(filld,'holes');
end

