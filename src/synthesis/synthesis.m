function im_synth = synthesis(disp_map,leftrgb,rightrgb,p)

    im_synth=zeros(size(leftrgb));
    %Fill in background with pixels from second image.
    for i=1:size(leftrgb,1)
        for j=1:size(leftrgb,2)
            new_x=round(j-disp_map(i,j)*(1-p));
            if(new_x>0 && new_x < size(leftrgb,2))
                im_synth(i,j,:)=rightrgb(i,new_x,:);
            end
        end
    end
    
    %fill in foreground with moved pixels from first image
    for i=1:size(leftrgb,1)
        for j=1:size(leftrgb,2)
            new_x=round(j-disp_map(i,j)*p);
            if(new_x>0 && new_x < size(leftrgb,2))
                im_synth(i,new_x,:)=leftrgb(i,j,:);
            end
        end
    end
    
    %fill in gaps using blurred vales
    im_filler=zeros(size(leftrgb));
    for i=1:size(leftrgb,1)
        for j=1:size(leftrgb,2)
            if(im_synth(i,j,1)==0 && im_synth(i,j,2)==0 && im_synth(i,j,3)==0)
                im_filler(i,j,:)=(leftrgb(i,j,:)+p*rightrgb(i,j,:))/2;
            end
        end
    end
    
    temp=im_filler(:,:,1)+im_filler(:,:,2)+im_filler(:,:,3);
    im_filler=imgaussfilt(im_filler,2);
    im_filler(temp==0)=0;
    im_synth=im_synth+im_filler;
    
    %convert back to uint8
    im_synth=uint8(im_synth);
end
