function  [d2,i2]=plockaurml(d1,i1,index);
% [d2,i2]=plockaurml(d1,i1,index) - skapar en ny matrislista
% som innehaller de element ur (d1,i1) som specificerats av index.

[d2,i2]=nyml;
[slask,bantal]=size(i1);
for i=index;
  if ( (i>0) & (i<=bantal) ),
    ilow=i1(1,i);
    ihigh=i1(2,i);
    [d2,i2]=laggtillml(d2,i2,d1(:,ilow:ihigh));
  end;
end;
