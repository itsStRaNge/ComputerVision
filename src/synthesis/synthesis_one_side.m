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
                %zz = repelem(squeeze(im_synth(i,new_x,:)),(j-new_x+1));
                %im_synth(i,new_x:j,:)=reshape(zz, size(im_synth(i,new_x:j,:)));     
        end
    end
    im_synth=uint8(im_synth);
end
