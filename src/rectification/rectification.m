function [JL, JR, HL, HR] = rectification(IL, IR, R, T, K,crop)
%% create projection matrix
pi_matrix = [1 0 0 0; 0 1 0 0; 0 0 1 0];

M = [R, (T)'; 0, 0, 0, 1];
PL = K * pi_matrix * eye(4,4);
PR = K * pi_matrix * M;

%% get rectification
[JL, JR, HL, HR] = cv_rectify(IL, PL, IR, PR);
    
    if(crop)
        bordersL=JL(:,:,1)+JL(:,:,2)+JL(:,:,3);
        bordersL(bordersL(:)~=0)=255;


        [I,J]=find(bordersL>max(bordersL(:))/2);

        IJ=[I,J];  
        [~,idx]=min(IJ*[1 1; 1 -1; -1 1; -1 -1].');
        cornersL=IJ(idx,:);
        cornersL(cornersL>size(bordersL,2))=size(bordersL,2);
        %upperleft->upperright->lowerleft->lowerright
        bordersR=JR(:,:,1)+JR(:,:,2)+JR(:,:,3);
        bordersR(bordersR(:)~=0)=255;


        [I,J]=find(bordersR>max(bordersR(:))/2);

        IJ=[I,J];  
        [~,idx]=min(IJ*[1 1; 1 -1; -1 1; -1 -1].');
        cornersR=IJ(idx,:);
        cornersR(cornersR>size(bordersR,2))=size(bordersR,2);
        
        l_limit=max([cornersL(1,2),cornersL(3,2),cornersR(1,2),cornersR(3,2)]);
        r_limit=min([cornersL(2,2),cornersL(4,2),cornersR(2,2),cornersR(4,2)]);
        u_limit=max([cornersL(1,1),cornersL(2,1),cornersR(1,1),cornersR(2,1)]);
        d_limit=min([cornersL(3,1),cornersL(4,1),cornersR(3,1),cornersR(4,1)]);
        
        %JL=JL(u_limit:d_limit,l_limit:r_limit);
        %JR=JR(u_limit:d_limit,l_limit:r_limit);
        
        crop_margin_x=max([l_limit,size(JL,2)-r_limit]);
        crop_margin_y=max([u_limit,size(JL,1)-d_limit]);
        JL=JL(crop_margin_y:(size(JL,1)-crop_margin_y),crop_margin_x:(size(JL,2)-crop_margin_x),:);
        JR=JR(crop_margin_y:(size(JR,1)-crop_margin_y),crop_margin_x:(size(JR,2)-crop_margin_x),:);
        
    end
    

end

