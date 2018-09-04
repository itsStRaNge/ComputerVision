function im_synth = synthesis_one_side(disp_map,leftrgb,rightrgb,p)
    
    im_synth=zeros(size(leftrgb));
    
    rowvls=1:size(leftrgb,2);
    
    m=repmat(rowvls,size(leftrgb,1),1);
    m=int16(m);
    
    new_x=m-disp_map.*p;
    new_x(new_x<0 | new_x > size(leftrgb,2))=m(new_x<0 | new_x > size(leftrgb,2));
    new_x=uint16(new_x);
    
    for i=1:size(leftrgb,1)
        for j=1:size(leftrgb,2)
                im_synth(i,new_x(i,j),:)=leftrgb(i,j,:);
                %rudimentary hole filling;
                %zz = repelem(squeeze(im_synth(i,new_x(i,j),:)),(j-new_x(i,j)+1));
                %im_synth(i,new_x(i,j):j,:)=reshape(zz, size(im_synth(i,new_x(i,j):j,:)));     
        end
    end
    
   
    %hole filling with linear interpolation
    for i=2:size(im_synth,1)
        for j=2:(size(im_synth,2)-5)
            if(im_synth(i,j,:)==0)
                hole_left=j;
                while(im_synth(i,j,:)==0 & j<(size(im_synth,2)-5))
                    j=j+1;
                end
                diff=squeeze(im_synth(i,j,:)-im_synth(i,hole_left-1,:));
                diff=diff*linspace(0,1,j+1-hole_left);
                diff=(diff+squeeze(im_synth(i,hole_left-1,:))*ones(j+1-hole_left,1)')';
                im_synth(i,hole_left:j,:)=reshape(diff,size(im_synth(i,hole_left:j,:)));
                
            end
        end
    end
    
    im_synth=uint8(im_synth);
end
