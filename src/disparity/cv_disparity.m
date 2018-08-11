function dispmap = cv_disparity(IL, IR)
% code reference:
% https://github.com/owlbread/MATLAB-stereo-image-disparity-map/blob/master/dispmap3ThisTimeItsPersonal.m

dispmap = zeros(size(IL),'single');

windowSize = 25;

halfSampleSize = 2;

[h, w] = size(IL);

for m = 1:h
   minr = max(1, m - halfSampleSize);
   maxr = min(h, m + halfSampleSize);
   
   disp(m/h);
   for n = 1:w
      minc = max(1, n-halfSampleSize);
      maxc = min(w, n+halfSampleSize);
      
      mind=0;
      maxd = min(windowSize, w-maxc);
      
      sampleA = IR(minr:maxr , minc:maxc);
      numBlocks = maxd - mind + 1;
      
      SADs = zeros(numBlocks,1);
      
      for i = mind : maxd
          sampleB = IL(minr:maxr, (minc+i):(maxc+i));
          blockIndex = i-mind+1;
          SADs(blockIndex, 1) = sum(sum(abs(sampleA-sampleB)));
      end
      
      [~, sorted] = sort(SADs);
      bestMatchIndex = sorted(1,1);
      d = bestMatchIndex + mind - 1;
      
      if ((bestMatchIndex == 1) || (bestMatchIndex == numBlocks))
          dispmap(m,n)=d;
      else
          C1=SADs(bestMatchIndex-1);
          C2=SADs(bestMatchIndex);
          C3=SADs(bestMatchIndex+1);
          dispmap(m,n) = d - (0.5 * (C3 - C1) / (C1 - (2*C2) + C3));
      end
   end
end
dispmap(dispmap(:) < 0) = 0;
end