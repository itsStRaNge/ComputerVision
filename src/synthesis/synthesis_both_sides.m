function im_synth = synthesis_both_sides(disp_left,disp_right,leftrgb,rightrgb,p)
    
    %%adjust gain and bias for image merging later,
    %
    leftrgb=single(leftrgb);
    rightrgb=single(rightrgb);
    
    mean_left=mean(leftrgb(:));
    mean_right=mean(rightrgb(:));
    std_left=std(leftrgb(:));
    std_right=std(rightrgb(:));
    
    %gain
    leftrgb=leftrgb+(p*(mean_right-mean_left));
    rightrgb=rightrgb-((1-p)*(mean_right-mean_left));
    
    
    %bias
    leftrgb=leftrgb*((1-p)*std_left+(p)*std_right)/std_left;
    rightrgb=rightrgb*((p)*std_left+(1-p)*std_right)/std_right;
    
    
    im_synth_l=zeros(size(leftrgb));
    im_synth_l=single(im_synth_l);
    
    rowvls=1:size(leftrgb,2);
    m=repmat(rowvls,size(leftrgb,1),1);
    m=int16(m);
    
    new_x=m-disp_left.*p;
    new_x(new_x<1 | new_x > size(leftrgb,2))=m(new_x<1 | new_x > size(leftrgb,2));
    new_x=uint16(new_x);
    
    for i=1:size(leftrgb,1)
        for j=1:size(leftrgb,2)
                im_synth_l(i,new_x(i,j),:)=leftrgb(i,j,:);
        end
    end
    
    im_synth_r=zeros(size(rightrgb));
    im_synth_r=single(im_synth_r);
    
    rowvls=1:size(rightrgb,2);
    m=repmat(rowvls,size(rightrgb,1),1);
    m=int16(m);
    
    new_x=m+disp_right.*(1-p);
    new_x(new_x<1 | new_x > size(rightrgb,2))=m(new_x<1 | new_x > size(rightrgb,2));
    new_x=int16(new_x);
    
    for i=1:(size(rightrgb,1)-1)
        for j=1:(size(rightrgb,2)-1)
                im_synth_r(i,new_x(i,j),:)=rightrgb(i,j,:);         
        end
    end
    
    %filling up with data from the other image
    im_synth_r=single(im_synth_r)+im_synth_l.*single(im_synth_r==0 & im_synth_l~=0);
    im_synth_l=single(im_synth_l)+im_synth_r.*single(im_synth_l==0 & im_synth_r~=0);
    
    %overlay depending on angle
    im_synth=im_synth_l*(1-p)+im_synth_r*(p);
    
    
    %hole filling with linear interpolation
    for i=2:size(im_synth,1)
        for j=2:size(im_synth,2)
            if(im_synth(i,j,:)==0)
                hole_left=j;
                while(im_synth(i,j,:)==0 & j<size(im_synth,2))
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
