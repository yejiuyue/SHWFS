clear
% clc
close all

pSubNear =54;   %���ӿ׾�������������
numSub = 17;     %�ӿ׾���Ŀ
% numPixel = 240;  
subPixel =54;   %ÿ���ӿ׾�16*16����
numPixel = subPixel*numSub; %����ֱ���
L_pixel = 3.75e-6; %������ش�С
f = 3e-3;       %΢͸������
wl = 632e-9;     %��������
L_subapt = subPixel*L_pixel;  %�ӿ׾��ߴ�
numSub = numPixel/subPixel;   %�ӿ׾���Ŀ
nSize = numSub*pSubNear;      %ȫ�ھ�������������

numPixel_DL = 5;
%f_sub = numPixel_DL*L_pixel*L_subapt/wl; %΢͸������
f_sub=f ;
b_digital=1;
nBytes=12;

numMode=11;
%% ��������������ھ�\������Ч�ӿ׾�
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

%% �궨������
flatWave = zeros(nSize,nSize);
[aryFlatCx, aryFlatCy, I_temp] = HS_SubCentroidAry1(flatWave, valueAry, mask1, wl, L_pixel, subPixel,f_sub, b_digital, nBytes);
tiltWave = zernike(2,nSize).*mask1;
% [aryCx, aryCy, I_temp] = HS_SubCentroidAry(tiltWave, valueAry, mask, wl, L_pixel, subPixel,f_sub, b_digital, nBytes);
% aryCx(8,8)-aryFlatCx(8,8)
% (max(tiltWave(:))-min(tiltWave(:)))/L_subapt/numSub*f/L_pixel
%% ģʽϵ���ع�����
D = zeros(2*aryNum, numMode);
%figure
% CenFR = zeros(2, aryNum, DM_num);
for nmode = 1 : numMode
    curMode = zernike(nmode+1,nSize).*mask1*5;   
    [aryTempCx, aryTempCy, I_temp] = HS_SubCentroidAry1(curMode, valueAry,mask1, wl, L_pixel, subPixel,f_sub, b_digital, nBytes);

 D(:, nmode) = HS_SubShiftVec(aryTempCx,aryFlatCx, aryTempCy, aryFlatCy, valueAry);
    D(:, nmode)=D(:, nmode);
%     imagesc(I_temp);drawnow
%     DMnum    
end

% max_shift = max(R_dm(:));
R_inv = pinv(D);
R_cond = cond(R_inv)
%% �޶�
%randcoe=for_zc(numMode,0.1);
% randcoe=[0,0,0,0,0,0,0,0,0,0,0]';
% wf=zeros(nSize,nSize);
% for nmode=1:numMode
%     wf=wf+randcoe(nmode)*zernike(nmode+1,nSize).*mask1;
% end
% figure;
% mesh(wf);
% [aryActCx, aryActCy, I_act] = HS_SubCentroidAry1(wf, valueAry,mask1, wl, L_pixel, subPixel,3e-3 ,b_digital, nBytes);
% [aryActCx1, aryActCy1, I_act1] = HS_SubCentroidAry1(wf, valueAry,mask1, wl, L_pixel, subPixel,4e-3, b_digital, nBytes);
% slopvec=3*HS_SubShiftVec1(aryActCx1,aryActCx, aryActCy1, aryActCy, valueAry);
% re_coe=R_inv*slopvec;
%slopvec=HS_SubShiftVec1(aryActCx,aryFlatCx, aryActCy, aryFlatCy, valueAry);
%%
randcoe1=[-11.68,  -42.5,	4.72,	1.06,	-2.47,	2.32,-2.90,	-0.17,-0.40,	0.34 ,0.33,]'/2;
wf1=zeros(nSize,nSize);
for nmode=1:numMode
    wf1=wf1+randcoe1(nmode)*zernike(nmode+1,nSize).*mask1;
end
% figure;
% mesh(wf);

[aryActCx, aryActCy, I_act] = HS_SubCentroidAry1(wf1, valueAry,mask1, wl, L_pixel, subPixel,3e-3 ,b_digital, nBytes);
 [aryActCx1, aryActCy1, I_act1] = HS_SubCentroidAry1(wf1, valueAry,mask1, wl, L_pixel, subPixel,3.5e-3, b_digital, nBytes);
 slopvec1=6*HS_SubShiftVec(aryActCx1,aryActCx, aryActCy1, aryActCy, valueAry);
slopvec=HS_SubShiftVec(aryActCx,aryFlatCx, aryActCy, aryFlatCy, valueAry);
re_coe1=R_inv*slopvec1;
re_coe=R_inv*slopvec*5;
rewf=zeros(nSize,nSize);
for nmode=1:numMode
    rewf=rewf+re_coe1(nmode)*zernike(nmode+1,nSize).*mask1;
end

imagesc(wf1-rewf);
%imagesc(I_act);
imshow(I_act,[]);
% Sx=aryActCx(find(aryActCx~=0));
% Sy=aryActCy(find(aryActCy~=0));
% S=[Sx,Sy];
% pointSH(S,I_act,54)
%plot(aryActCx(CoorBuenas(:,3)+radioMLpxs),'o','MarkerSize',1,'MarkerEdgeColor','r');
