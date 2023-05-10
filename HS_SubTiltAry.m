function [arydSubTiltX, arydSubTiltY] = HS_SubTiltAry(arydWf, aryuValueAry, aryuValueArea, tiltX, tiltY)

uSubNumWide = size(aryuValueAry, 1);
uWfWide = size(arydWf, 1);
uSubWide = uWfWide / uSubNumWide;

arydSubTiltX = zeros(uSubNumWide);
arydSubTiltY = zeros(uSubNumWide);

aryuCircle = aryuValueArea;


% fftsize=2*round(lamda*f_microlens/pixel/(numSubPixel*pixel/uSubWide)/2);
% I_total=zeros(uSubNumWide*numSubPixel,uSubNumWide*numSubPixel);

% [c_x,c_y]=meshgrid(linspace(1,numSubPixel,numSubPixel));

for uRow = 1 : uSubNumWide
    for uColumn = 1 : uSubNumWide
        if aryuValueAry(uRow, uColumn) == 1 %若子孔径有效，挖出子孔径波前
            uRow_s = (uRow - 1) * uSubWide + 1;
            uRow_e = uRow * uSubWide;
            uColumn_s = (uColumn - 1) * uSubWide + 1;
            uColumn_e = uColumn * uSubWide;
            
            
            arydSubWf = arydWf(uRow_s : uRow_e, uColumn_s : uColumn_e);
            aryuCircleSub = aryuCircle(uRow_s : uRow_e, uColumn_s : uColumn_e);
            aryTiltX = tiltX(uRow_s : uRow_e, uColumn_s : uColumn_e);
            aryTiltY = tiltY(uRow_s : uRow_e, uColumn_s : uColumn_e);

            %计算子孔径波前斜率
            
            aryTiltX(aryuCircleSub==1) =aryTiltX(aryuCircleSub==1)-mean2(aryTiltX(aryuCircleSub==1));
            aryTiltY(aryuCircleSub==1) =aryTiltY(aryuCircleSub==1)-mean2(aryTiltY(aryuCircleSub==1));
            arydSubWf(aryuCircleSub==1)=arydSubWf(aryuCircleSub==1)-mean2(arydSubWf(aryuCircleSub==1));
            arydSubTiltX(uRow, uColumn) = sum(sum(arydSubWf .* aryTiltX)) / sum(sum(aryTiltX.^2));
            arydSubTiltY(uRow, uColumn) = sum(sum(arydSubWf .* aryTiltY)) / sum(sum(aryTiltY.^2));


         end
    end
end
% 
% for uRow = 1 : uSubNumWide
%     for uColumn = 1 : uSubNumWide
%         if aryuValueAry(uRow, uColumn) == 1 %挖出子孔径波前
%             %计算子孔径远场光斑质心
%             arydSubI = I_total((uRow-1)*numSubPixel+1:uRow*numSubPixel,(uColumn-1)*numSubPixel+1:uColumn*numSubPixel);
%             arydSubTiltX(uRow, uColumn) = sum(sum(arydSubI .* c_x)) / sum(sum(arydSubI));
%             arydSubTiltY(uRow, uColumn) = sum(sum(arydSubI .* c_y)) / sum(sum(arydSubI));
%         end
%     end
% end
