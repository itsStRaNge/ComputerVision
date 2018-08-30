function [data,index]=laggtillml(d1,i1,d2,i2);
% Med tre inargument fungerar
% [data,index]=laggtillml(d1,i1,d2) så att matrisen data index
% består av alla element i listan (d1,i1) plus matrisen d2.
% Med fyra inargument konkateneras de två listorna (d1,i1) och (d2,i2)
% Resultatet hamnar i listan (data,index).

if (nargin == 3),
 [slask,antal]=size(d2);
 [slask,bantal]=size(d1);
 data=[d1 d2];
 index=[i1 [bantal+1;bantal+antal]];
elseif (nargin == 4)
 [slask,dantal]=size(d1);
 data=[d1 d2];
 index=[i1 (i2+dantal*ones(size(i2)))];
else
  error('laggtillml fungerar bara med 3 eller 4 element.');
end;


