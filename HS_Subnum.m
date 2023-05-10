function [Subnum ,SubNum,valueNumX,valueNumY]= HS_Subnum(slopvec1,center,subPixel,valueAry) 
uNum=size(center);
Subnum =zeros(uNum);
Subnum(:,1)=slopvec1(1:uNum,1);
Subnum(:,2)=slopvec1(uNum+1:2*uNum,1);
SubNum=fix(Subnum(:,:)/subPixel*2);
row = size(valueAry, 1);
column = size(valueAry, 2);
valueNumX=zeros(row );
valueNumY=zeros(column );
i=1;
for ri = 1 : row 
    for ci = 1 : column
   if valueAry(ri ,ci ) ==0
   valueNumX(ri ,ci )=nan;
   valueNumY(ri ,ci )=nan;
   end
  if valueAry(ri ,ci ) ==1
   valueNumX(ri ,ci )=SubNum(i,1);
   valueNumY(ri ,ci )=SubNum(i,2);
  i=i+1;
   end
    end
end

end