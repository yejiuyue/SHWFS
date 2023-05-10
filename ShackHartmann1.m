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
b_digital=1;
nBytes=8;
numMode=11;
%% 生成坐标与光束口径\计算有效子孔径
[x_dot,y_dot]=meshgrid(linspace(-1,1,nSize));
r=sqrt(x_dot.^2+y_dot.^2);
mask = zeros(nSize,nSize);
mask(r<=0.8) =1;
%mask = ones(nSize,nSize);
mask1 = zeros(nSize,nSize);
mask1(r<=0.8) =1;
valueAry = calc_valueAryFromArea(numSub,mask);
aryNum = sum(valueAry(:));
% figure;
% mesh(valueAry );

%% 标定哈特曼
flatWave = zeros(nSize,nSize);
[aryFlatCx, aryFlatCy, I_temp] = HS_SubCentroidAry(flatWave, valueAry, mask1, wl, L_pixel, subPixel,f_sub, b_digital, nBytes);
tiltWave = zernike(2,nSize).*mask1;
% [aryCx, aryCy, I_temp] = HS_SubCentroidAry(tiltWave, valueAry, mask, wl, L_pixel, subPixel,f_sub, b_digital, nBytes);
% aryCx(8,8)-aryFlatCx(8,8)
% (max(tiltWave(:))-min(tiltWave(:)))/L_subapt/numSub*f/L_pixel
%% 模式系数重构矩阵
%D = zeros(2*aryNum, numMode);
%figure
% CenFR = zeros(2, aryNum, DM_num);
for nmode = 1 : numMode
    curMode = zernike(nmode+1,nSize).*mask1;   
    [aryTempCx, aryTempCy, I_temp] = HS_SubCentroidAry(curMode, valueAry,mask1, wl, L_pixel, subPixel,f_sub, b_digital, nBytes);
%    [aryTempCx1, aryTempCy1, I_temp1] = HS_SubCentroidAry(curMode, valueAry,mask1, wl, L_pixel, subPixel,1.2*f_sub, b_digital, nBytes);
     %D(:, nmode) = HS_SubShiftVec(aryTempCx1-aryTempCx,aryFlatCx,aryTempCy1-aryTempCy, aryFlatCy, valueAry);
    D(:, nmode) = HS_SubShiftVec(aryTempCx,aryFlatCx,aryTempCy, aryFlatCy, valueAry);
    D(:, nmode)=D(:, nmode);
%     imagesc(I_temp);drawnow
%     DMnum    
end

% max_shift = max(R_dm(:));
R_inv = pinv(D);
R_cond = cond(R_inv)
%% 复原实际像差
%randcoe=for_zc(numMode,0.1);
randcoe=[-11.68,-42.5,	4.72,	1.06,	-2.47,	2.32,	-2.90,	-0.17,-0.40,	0.34,	0.33,]'/2;
wf=zeros(nSize,nSize);
for nmode=1:numMode
    wf=wf+randcoe(nmode)*zernike(nmode+1,nSize).*mask1;
end
 figure;
 mesh(wf);
[aryActCx, aryActCy, I_act] = HS_SubCe
ntroidAry(wf, valueAry,mask1, wl, L_pixel, subPixel,f_sub, b_digital, nBytes);
%[aryActCx1, aryActCy1, I_act1] = HS_SubCentroidAry(wf, valueAry,mask1, wl, L_pixel, subPixel,1.1*f_sub, b_digital, nBytes);
%slopvec=10*HS_SubShiftVec(aryActCx1,aryActCx, aryActCy1, aryActCy, valueAry);
slopvec=HS_SubShiftVec(aryActCx,aryFlatCx, aryActCy, aryFlatCy, valueAry);
re_coe=R_inv*slopvec;
rewf=zeros(nSize,nSize);
for nmode=1:numMode
    rewf=rewf+re_coe(nmode)*zernike(nmode+1,nSize).*mask1;
end
imagesc(wf-rewf);
imshow(I_act1,[]);
pointSH(subPixel ,I_act1,numPixel/2,54,1.4)
%plot(aryActCx(CoorBuenas(:,3)+radioMLpxs),'o','MarkerSize',1,'MarkerEdgeColor','r');
%set(h,'alphadata',~isnan( rewf.*mask1))