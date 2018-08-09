 function [M]   = normalizeImage(Im)
        [m,n]= size(Im);
        if(m==1 || n==1 || size(Im,3)~=1)
            error('please use a two-dimensional image');
        end        
        M=Im(:);
        M=M-mean(M);
        M=M/std(M);
        M=reshape(M,m,n);
        %figure;
        %imshow(M);
 end