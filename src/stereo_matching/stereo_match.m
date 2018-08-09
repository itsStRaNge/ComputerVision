%Takes two rektified grayscale M by N images, calculates disparity map
function [Disparity] = stereo_match(Im1Rect,Im2Rect, w)
    Disparity=zeros(size(Im1Rect));
    
    for i=w:(size(Im1Rect,1)-w)
        for j=w:(size(Im1Rect,2)-w)
            window1=Im1Rect((i-(w-1)):(i+(w-1)),(j-(w-1)):(j+(w-1)));
            
            %find mac ncc along x coordinate
            maxncc=0;
            disp=0;
            for k=w:(size(Im2Rect,2)-w)
                window2=Im2Rect((i-(w-1)):(i+(w-1)),(k-(w-1)):(k+(w-1)));
                currncc=NCC(window1,window2);
                if(currncc>maxncc)
                    disp=k-j;
                    maxncc=currncc;
                end
            end
            Disparity(i,j)=disp;
        end
    end
    
    
    function [res] = NCC(M1,M2)
        if(size(M1)~= size(M2))
            error('matrices not of same size');
        end
        res =  trace(M1'*M2)* 1/(size(M1,1)*size(M1,2)-1);
    end
end