clear
% clc
close all

pSubNear = 54;   %单子孔径近场采样点数
numSub = 17;     %子孔径数目
% numPixel = 240;  
subPixel = 54;   %每个子孔径16*16像素
numPixel = subPixel*numSub; %相机分辨率
L_pixel = 3.75e-6; %相机像素大小
f = 3e-3;       %微透镜焦距
wl = 632e-9;     %工作波长
L_subapt = subPixel*L_pixel;  %子孔径尺寸
numSub = numPixel/subPixel;   %子孔径数目
nSize = numSub*pSubNear;      %全口径近场采样点数

numPixel_DL = 5;
%f_sub = numPixel_DL*L_pixel*L_subapt/wl; %微透镜焦距
f_sub=f;
b_digital=0;
nBytes=16;

numMode=11;
%% 生成坐标与光束口径\计算有效子孔径
[x_dot,y_dot]=meshgrid(linspace(-1,1,nSize));
r=sqrt(x_dot.^2+y_dot.^2);
mask = zeros(nSize,nSize);
mask(r<=1) =1;
%mask = ones(nSize,nSize);
mask1 = zeros(nSize,nSize);
mask1(r<=1) =1;
valueAry = calc_valueAryFromArea(numSub,mask);
aryNum = sum(valueAry(:));
% figure;
% mesh(valueAry );

%% 标定哈特曼
flatWave = zeros(nSize,nSize);
[aryFlatCx, aryFlatCy, I_temp] = HS_SubCentroidAry1(flatWave, valueAry, mask1, wl, L_pixel, subPixel,f_sub, b_digital, nBytes);
tiltWave = zernike(2,nSize).*mask1;
% [aryCx, aryCy, I_temp] = HS_SubCentroidAry(tiltWave, valueAry, mask, wl, L_pixel, subPixel,f_sub, b_digital, nBytes);
% aryCx(8,8)-aryFlatCx(8,8)
% (max(tiltWave(:))-min(tiltWave(:)))/L_subapt/numSub*f/L_pixel
%% 模式系数重构矩阵
D = zeros(2*aryNum, numMode);
%figure
% CenFR = zeros(2, aryNum, DM_num);
for nmode = 1 : numMode
    curMode = zernike(nmode+1,nSize).*mask1*5;   
    [aryTempCx, aryTempCy, I_temp] = HS_SubCentroidAry1(curMode, valueAry,mask1, wl, L_pixel, subPixel,f_sub, b_digital, nBytes);
    D(:, nmode) = HS_SubShiftVec1(aryTempCx,aryFlatCx, aryTempCy, aryFlatCy, valueAry);
    D(:, nmode)=D(:, nmode);
%     imagesc(I_temp);drawnow
%     DMnum    
end

% max_shift = max(R_dm(:));
R_inv = pinv(D);
R_cond = cond(R_inv)
%% 复原实际像差
%randcoe=for_zc(numMode,0.1);
randcoe=[0,0,15,0,0,0,0,0,0,0,0]';
wf=zeros(nSize,nSize);
for nmode=1:numMode
    wf=wf+randcoe(nmode)*zernike(nmode+1,nSize).*mask1;
end
% figure;
% mesh(wf);
[aryActCx, aryActCy, I_act] = HS_SubCentroidAry1(wf, valueAry,mask1, wl, L_pixel, subPixel,f_sub, b_digital, nBytes);
slopvec=HS_SubShiftVec1(aryActCx,aryFlatCx, aryActCy, aryFlatCy, valueAry);
re_coe=R_inv*slopvec*5;
rewf=zeros(nSize,nSize);
for nmode=1:numMode
    rewf=rewf+re_coe(nmode)*zernike(nmode+1,nSize).*mask1;
end
imagesc(I_act);
%imshow(I_act,[]);
pointSH(subPixel ,I_act,numPixel/2,54,1.4)
%plot(aryActCx(CoorBuenas(:,3)+radioMLpxs),'o','MarkerSize',1,'MarkerEdgeColor','r');
