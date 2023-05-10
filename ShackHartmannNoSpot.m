clear
clc
close all

pSubNear = 64;   %���ӿ׾�������������
numSub = 8;     %�ӿ׾���Ŀ
% numPixel = 240;  
subPixel = 16;   %ÿ���ӿ׾�16*16����
numPixel = subPixel*numSub; %����ֱ���
L_pixel = 10; %������ش�С
f = 10e3;       %΢͸������
wl = 532e-3;     %��������
L_subapt = subPixel*L_pixel;  %�ӿ׾��ߴ�
numSub = numPixel/subPixel;   %�ӿ׾���Ŀ
nSize = numSub*pSubNear;      %ȫ�ھ�������������

numPixel_DL = 5;
f_sub = numPixel_DL*L_pixel*L_subapt/wl; %΢͸������

b_digital=1;
nBytes=14;

numMode=65;
%% ��������������ھ�\������Ч�ӿ׾�
[x_dot,y_dot]=meshgrid(linspace(-1,1,nSize));
r=sqrt(x_dot.^2+y_dot.^2);
mask = zeros(nSize,nSize);
mask(r<=1) = 1;

valueAry = calc_valueAryFromArea(numSub,mask);
aryNum = sum(valueAry(:));
%% �궨������
tiltX=zernike(2,nSize).*mask;
tiltY=zernike(3,nSize).*mask;
flatWave = zeros(nSize,nSize);
[aryFlatTx, aryFlatTy] = HS_SubTiltAry(flatWave, valueAry, mask, tiltX, tiltY );
tiltWave = zernike(2,nSize).*mask;
% [aryCx, aryCy, I_temp] = HS_SubCentroidAry(tiltWave, valueAry, mask, wl, L_pixel, subPixel,f_sub, b_digital, nBytes);
% aryCx(8,8)-aryFlatCx(8,8)
% (max(tiltWave(:))-min(tiltWave(:)))/L_subapt/numSub*f/L_pixel
%% ģʽϵ���ع�����
D = zeros(2*aryNum, numMode);
% figure
% CenFR = zeros(2, aryNum, DM_num);
for nmode = 1 : numMode
    curMode = zernike(nmode+1,nSize).*mask;   
    [aryTempTx, aryTempTy] = HS_SubTiltAry(curMode, valueAry,mask, tiltX, tiltY);
    D(:, nmode) = HS_SubShiftVec1(aryTempTx,aryFlatTx, aryTempTy, aryFlatTy, valueAry);
%     imagesc(I_temp);drawnow
%     DMnum    
end

% max_shift = max(R_dm(:));
R_inv = pinv(D);
R_cond = cond(R_inv)
%% ��ԭʵ�����
tiltcoe_err = zeros(2,1);
count=1;
figure;
for numReconMode=2:numMode
    randcoe=zeros(1,numMode);
    randcoe(1)=1;randcoe(2)=1;
    randcoe(numReconMode)=1;
% randcoe=for_zc(numMode,1);
wf=zeros(nSize,nSize);
for nmode=1:numMode
    wf=wf+randcoe(nmode)*zernike(nmode+1,nSize).*mask;
end
imagesc(wf);drawnow;
[aryActTx, aryActTy] = HS_SubTiltAry(wf, valueAry,mask, tiltX, tiltY );
slopvec=HS_SubShiftVec1(aryActTx,aryFlatTx, aryActTy, aryFlatTy, valueAry);
re_coe=R_inv*slopvec;
tiltcoe_err(1,count)=re_coe(1)-randcoe(1);
tiltcoe_err(2,count)=re_coe(2)-randcoe(2);
count=count+1;
end
% rewf=zeros(nSize,nSize);
% for nmode=1:numMode
%     rewf=rewf+re_coe(nmode)*zernike(nmode+1,nSize).*mask;
% end