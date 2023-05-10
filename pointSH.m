function [] = pointSH(I_act,d)
%DEZERNIKE 此处显示有关此函数的摘要
%   movex=(Xcenter-x).*3.75e-6./7e-3;
%lens=shstruct.lens      ;             % 子透镜个数


lens_res=d;

% X0=0;
% Y0=0;
% 
hold on
 [m,n]=size(I_act);
 nspotx=fix((n/2-d/2)/lens_res);%半径内包含的中心点
  nspoty=fix((m/2-d/2)/lens_res);
% framed=shstruct. framed;
centerx=zeros(2*nspotx+1,2*nspoty+1);
centery=zeros(2*nspotx+1,2*nspoty+1);
for i = 1:(2*nspotx+1)
   for j = 1:(2*nspoty+1)      
centerx(i,j)=(n/2-nspotx*d)+(i-1)*d;
centery(i,j)=(m/2-nspoty*d)+(j-1)*d;
%         if(sum(sum(len_t)) < valid_num)
%              I_act((i-1) * lens_res + 1 : i * lens_res , ...
%                 (j-1) * lens_res + 1 : j * lens_res) = 0;
%         end
    end
end
 %plot(x1(:,1),y1(:,3),'o','MarkerSize',2,'MarkerEdgeColor','r')
 %% center
% center=mean(mean(xcenter))
cx=n/2;
cy=m/2;
  %有效孔径数筛选
%x2(isnan(x2))=0;
%y2(isnan(y2))=0;
%sum1(isnan(sum1))=0;
idx=find(centerx>0);
centerx=centerx(idx);
idy=find(centery>0);
centery=centery(idx);
hold on;
T=1;
for i=1:length(centery)
if  (centerx(i)-cx)^2+(centery(i)-cy)^2<(900/2)^2
center(T,1)=centerx(i);
center(T,2)=centery(i);
T=T+1;
 end
end
% sum=sum1(idx);
%  plot(y,x,'o','MarkerSize',2,'MarkerEdgeColor','r')
%  plot(center(:,1),center(:,2),'o','MarkerSize',1,'MarkerEdgeColor','k')

nspots=length(center);
c=center;
for i=1:length(c)
    %(53.3333.*17>c(2)&&c(2)>960/18)&&(53.3333.*23>c(1)&&c(1)>960/18)
    %c = round(c);
    minx = c(i,1) - d/2;
    maxx = c(i,1) + d/2;
    miny = c(i,2) - d/2;
    maxy = c(i,2) +d/2;

    box = round([minx, maxx, miny, maxy]);
   % sfigure(6);
    squaregrid(i, :) = box;
    rectangle('Position', [minx, miny, maxx-minx+1, maxy-miny+1], ...
       'LineWidth', 0.2, 'EdgeColor', 'w');
end
r=n.*0.8;
%c=[cx,cy];
%hold on
%L=linspace(0,2.*pi);
%  plot(c(1) + r*cos(L), c(2) + r*sin(L), 'r');
 % plot(c(1), c(2), 'xm', 'MarkerSize', 13);


end
