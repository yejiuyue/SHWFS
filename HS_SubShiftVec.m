function vecdSubShift = HS_SubShiftVec(arydSubCentoridX, arydSubCentoridX0,arydSubCentroidY, arydSubCentroidY0,aryuValueAry)

% uValueSubNum = sum(aryuValueAry(:));
% uSubNumWide = size(aryuValueAry, 1);
% vecdSubShift = zeros(2 * uValueSubNum, 1);
% 
% uNum = 1;
% for uRow = 1 : uSubNumWide
%     for uColumn = 1 : uSubNumWide
%         if aryuValueAry(uRow, uColumn) == 1
%             vecdSubShift(2 * uNum - 1) = arydSubCentoridX(uRow, uColumn)-arydSubCentoridX0(uRow, uColumn);
%             vecdSubShift(2 * uNum) = arydSubCentroidY(uRow, uColumn)-arydSubCentroidY0(uRow, uColumn);
%             uNum = uNum + 1;
%         end
%     end
% end
uNum=size(arydSubCentoridX0,1);
uNum1=size(arydSubCentoridX,1);

vecdSubShift=zeros(2*uNum,1);
vecdSubShift(1:uNum,1)=arydSubCentoridX(1:uNum)-arydSubCentoridX0(1:uNum);
vecdSubShift(uNum+1:2*uNum,1)=arydSubCentroidY(uNum1-uNum+1:end)-arydSubCentroidY0(1:uNum);
if uNum1<uNum
 uNum=uNum1
end
end
