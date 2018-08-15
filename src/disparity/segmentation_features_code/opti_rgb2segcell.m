function segcell = opti_rgb2segcell(img,iBinNum) 

%function mSegmentImg = HillClimbingSegment(img,iBinNum)
%Hill-Climbing Algorithm for Color Image Segmentation.
%   IDX = KMEANS(X, K) partitions the points in the N-by-P data matrix
%   X into K clusters.  This partition minimizes the sum, over all
%   clusters, of the within-cluster sums of point-to-cluster-centroid
%   distances.  Rows of X correspond to points, columns correspond to
%   variables.  KMEANS returns an N-by-1 vector IDX containing the
%   cluster indices of each point.  By default, KMEANS uses squared
%   Euclidean distances.
%
%   mSegmentImg = HillClimbingSegment(sImgPath,iBinNum)
%
%   Input Parameters:
%       Img        -     input image
%       iBinNum         -    the number of histogram bins in each dimension
%   
%   Output Parameters:
%       mSegmentImg     -    the label image where each pixel is the
%                            cluster label it belongs to
%
%
%   Example:
%       mSegmentImg = HillClimbingSegment('./test.jpg',10);
%
%   See also RGB2Lab, kmeans.



% Conversion from RGB to CIE Lab
%fprintf('Converting input image from RGB to CIE Lab ... ');
%img = imread(sImgPath);


R = reshape(double(img(:,:,1)),[size(img,1),size(img,2)]);
G = reshape(double(img(:,:,2)),[size(img,1),size(img,2)]);
B = reshape(double(img(:,:,3)),[size(img,1),size(img,2)]);
[L,a,b] = RGB2Lab(R,G,B);
% Build 3D color histogram

[LabHist,histCenters] = Build3DColorHistogram(L(:),a(:),b(:),iBinNum);

% Search for histogram peak
vSeed = SearchLocalMaximum(LabHist);
data = [L(:),a(:),b(:)];
[IDX,C] = kmeans(data,length(vSeed),'start',histCenters(vSeed,:),'emptyaction','drop');
% Display segmentation result
mSegmentImg = reshape(IDX,[size(img,1),size(img,2)]);
%imshow(label2rgb(mSegmentImg));
[row_img, col_img]=size(rgb2gray(img));
level = cell(iBinNum,1);
level(:) = {zeros(row_img, col_img)};
oo= 255*ones(row_img, col_img);
[value,ia,ix]=unique(mSegmentImg);

for i=1:length(value)
level{i}(mSegmentImg== value(i))=oo(mSegmentImg== value(i));
end

for q=1:length(level)
 se = strel('disk',1); %Create a disk-shaped structuring element with a radiusof 1 pixels.Remove areas having a radius less than 1 pixels 
 morpho_final=imopen(level{q},se);
 [L,num] = bwlabel(morpho_final);  %L Has connected components labeled with a number.num= number of connected components.
 ar=zeros(num);
 
 for i=1:num
    ar(i) = bwarea(L==i);      %to remove areas smaller than 1000.
 end
 
    x = find(ar>600);          %x= [label of areas>1000]
 
 for i=1:length(x)
   emptycells{q,i}=(L==x(i));
 end
 
end
segcell=emptycells(cellfun(@isempty,emptycells)==0);




function vSeed = SearchLocalMaximum(dataHist)
%
iBinNum = 1;
for i = 1:length(size(dataHist))
    iBinNum = iBinNum*size(dataHist,i);
end

vSeed = [];
for i = 1:iBinNum
    vNBins = CalcNeighborBins(size(dataHist),i);
    if (sum((dataHist(i)-dataHist(vNBins))>0)==length(vNBins))
        vSeed = [vSeed;i];
    end
end

return;


function vNBins = CalcNeighborBins(HistSize,iBin)
% 

[I1,I2,I3] = ind2sub(HistSize,iBin);

vBin1 = []; vBin2 = []; vBin3 = [];
for k = I3-1:I3+1
    for i = I1-1:I1+1
        for j = I2-1:I2+1
            if ((i~=I1 | j~=I2 | k~=I3) & ...
                ((i>0&i<=HistSize(1)) & (j>0&j<=HistSize(2)) & (k>0&k<=HistSize(3))))
                vBin1 = [vBin1;i];
                vBin2 = [vBin2;j];
                vBin3 = [vBin3;k];
            end
        end % end for j
    end % end for i
end % end for k

vNBins = sub2ind(HistSize,vBin1,vBin2,vBin3);

return;

function [vColorHist,histCenters] = Build3DColorHistogram(vChannel1,vChannel2,vChannel3,iBinNum)
% Generate 3D color histogram from 3 channels

[Chist1,Cbin1] = hist(vChannel1(:),iBinNum);
[Cdist1,Cidx1] = min(abs(repmat(vChannel1(:),[1,iBinNum])-repmat(Cbin1,[length(vChannel1(:)),1])),[],2);
[Chist2,Cbin2] = hist(vChannel2(:),iBinNum);
[Cdist2,Cidx2] = min(abs(repmat(vChannel2(:),[1,iBinNum])-repmat(Cbin2,[length(vChannel2(:)),1])),[],2);
[Chist3,Cbin3] = hist(vChannel3(:),iBinNum);
[Cdist3,Cidx3] = min(abs(repmat(vChannel3(:),[1,iBinNum])-repmat(Cbin3,[length(vChannel3(:)),1])),[],2);

ind = sub2ind([iBinNum,iBinNum,iBinNum],Cidx1,Cidx2,Cidx3);
vColorHist = zeros(iBinNum,iBinNum,iBinNum);
for i = 1:iBinNum^3
    vColorHist(i) = sum(ind==i);
end

histCenters = [repmat(Cbin1(:),[size(vColorHist,2)*size(vColorHist,3),1]),...
               repmat(Cbin2(:),[size(vColorHist,1)*size(vColorHist,3),1]),...
               repmat(Cbin3(:),[size(vColorHist,1)*size(vColorHist,2),1])];

return;

