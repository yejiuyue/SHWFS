function [valueAry,Center]= calc_valueAryFromArea(subNum, area)

row = size(area, 1);
column = size(area, 2);

subSizeR = 53.33;
subSizeC =53.33;
S=1;
Center = zeros(subNum^2, 2);
valueAry = zeros(subNum);
for ri = 1 : subNum
    for ci = 1 : subNum
        
        temp = area(round(1+(ri-1)*subSizeR) : round(ri*subSizeR), round(1+(ci-1)*subSizeC) : round(ci*subSizeC));
        tempR = size(temp, 1);
        tempC = size(temp, 2);
 
        if sum(temp(:)) / tempR / tempC >= 0.5
            c_row = (ri -1)* subSizeR +1/2+ subSizeR /2;
            c_col = (ci-1)* subSizeC+1/2+ subSizeC/2; 
            Center(S,:)=[c_col,c_row];
            valueAry(ri ,ci) = 1;
           S=S+1;
     
        end
         
    end
end
Center(S+1:end,:) = [];
% end

% X0=0;
% Y0=0;
% 
% [m,n]=size(area);
%  nspotx=fix((n/2-subNum/2)/subNum);%半径内包含的中心点
%  nspoty=fix((m/2-subNum/2)/subNum);
% % framed=shstruct. framed;
% centerx=zeros(2*nspotx+1,2*nspoty+1);
% centery=zeros(2*nspotx+1,2*nspoty+1);
% for i = 1:(2*nspotx+1)
%    for j = 1:(2*nspoty+1)      
% centerx(i,j)=(n/2-nspotx*d)+(i-1)*d;
% centery(i,j)=(m/2-nspoty*d)+(j-1)*d;
% %         if(sum(sum(len_t)) < valid_num)
% %              framed((i-1) * lens_res + 1 : i * lens_res , ...
% %                 (j-1) * lens_res + 1 : j * lens_res) = 0;
% %         end
%     end
% end
%  %plot(x1(:,1),y1(:,3),'o','MarkerSize',2,'MarkerEdgeColor','r')
%  %% center
%  %center=mean(mean(xcenter))
% cx=n/2+X0;
% cy=m/2+Y0;
%  %有效孔径数筛选
% % x2(isnan(x2))=0;
% % y2(isnan(y2))=0;
% % sum1(isnan(sum1))=0;
% idx=find(centerx>0);
% centerx=centerx(idx);
% %idy=find(centery>0);
% centery=centery(idx);
% hold on;
% T=1;
% for i=1:length(centery)
% if  (centerx(i)-cx)^2+(centery(i)-cy)^2<(n/2.*R)^2
% center(T,1)=centerx(i);
% center(T,2)=centery(i);
% T=T+1;
%  end
% end
% %sum=sum1(idx);
%  %plot(y,x,'o','MarkerSize',2,'MarkerEdgeColor','r')
%   %plot(center(:,1),center(:,2),'o','MarkerSize',2,'MarkerEdgeColor','r')
% 
% nspots=length(center);
% c=center;
% for i=1:length(c)
%     %(53.3333.*17>c(2)&&c(2)>960/18)&&(53.3333.*23>c(1)&&c(1)>960/18)
%     %c = round(c);
%     minx = c(i,1) - d/2;
%     maxx = c(i,1) + d/2;
%     miny = c(i,2) - d/2;
%     maxy = c(i,2) +d/2;
% 
%     box = round([minx, maxx, miny, maxy]);
%    % sfigure(6);
%     squaregrid(i, :) = box;
%     valueAry(ri ,ci) = 1
%   
% end
end
