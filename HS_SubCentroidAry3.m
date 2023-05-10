      function [arydSubCentroidX, arydSubCentroidY, I_total,fftsize] = HS_SubCentroidAry(arydWf, aryuValueAry, aryuValueArea, lamda, pixel, numSubPixel,f_microlens, b_digital, nBytes)

uSubNumWide = size(aryuValueAry, 1);
uWfWide = size(arydWf, 1);
uSubWide = uWfWide / uSubNumWide;

arydSubCentroidX = zeros(uSubNumWide);
 arydSubCentroidY = zeros(uSubNumWide);

aryuCircle = aryuValueArea;
L=200e-6;
fftsize=2*numSubPixel;
%fftsize=2*round(lamda*f_microlens/pixel/(numSubPixel*pixel/uSubWide)/2);
I_total=zeros(uSubNumWide*numSubPixel,uSubNumWide*numSubPixel);

[c_x,c_y]=meshgrid(linspace(1,numSubPixel,numSubPixel));

for uRow = 1 : uSubNumWide
    for uColumn = 1 : uSubNumWide
        if aryuValueAry(uRow, uColumn) == 1 %���ӿ׾���Ч���ڳ��ӿ׾���ǰ
            uRow_s = (uRow - 1) * uSubWide + 1;
            uRow_e = uRow * uSubWide;
            uColumn_s = (uColumn - 1) * uSubWide + 1;
            uColumn_e = uColumn * uSubWide;
%             uRow_s = valueAryR(uRow,uColumn);
%             uRow_e = valueAryR(uRow,uColumn)+valueAryRS(uRow,uColumn)-1;
%             uColumn_s = valueAryC(uRow,uColumn);
%             uColumn_e = valueAryC(uRow,uColumn)+valueAryCS(uRow,uColumn)-1;
%             
%             fftsize_R = 2*round(lamda*f_microlens*scale_num^2/pixel/(numSubPixel*pixel/valueAryRS(uRow,uColumn))/2);
%             fftsize_C = 2*round(lamda*f_microlens*scale_num^2/pixel/(numSubPixel*pixel/valueAryCS(uRow,uColumn))/2);
            
            arydSubWf = arydWf(uRow_s : uRow_e, uColumn_s : uColumn_e);
            aryuCircleSub = aryuCircle(uRow_s : uRow_e, uColumn_s : uColumn_e);
            %�����ӿ׾�Զ���������
%             arydSubE = aryuCircleSub.*exp(1i*2*pi/lamda*arydSubWf);
%             arydSubI_temp = abs(fftshift(fft2(arydSubE,fftsize,fftsize))).^2;
%             arydSubI = arydSubI_temp(fftsize/2+1-numSubPixel/2:fftsize/2+numSubPixel/2,fftsize/2+1-numSubPixel/2:fftsize/2+numSubPixel/2);
            arydSubE = aryuCircleSub.*exp(1i*2*pi*arydSubWf);
%             arydSubE = aryuCircleSub.*exp(1i*2*pi*arydSubWf);
            % arydSubI_temp=angularspectrum(arydSubE,fftsize,fftsize,f_microlens,lamda)
       
          %arydSubI_temp=propagacionFresnel(arydSubE,L,lamda,f_microlens);
         arydSubI_temp=  propagpectrum(arydSubE,L,lamda,f_microlens,3e-3);
           %   arydSubI_temp = abs(fftshift(fft2(arydSubE,fftsize,fftsize))).^2;
            
%             arydSubCentroidX(uRow, uColumn) = sum(sum(arydSubI .* c_x)) / sum(sum(arydSubI));
%             arydSubCentroidY(uRow, uColumn) = sum(sum(arydSubI .* c_y)) / sum(sum(arydSubI));
            %���ӹ�߷���ȫ����
            c_row = (uRow-1)*numSubPixel+1+numSubPixel/2;
            c_col = (uColumn-1)*numSubPixel+1+numSubPixel/2;         
            
            if c_row-fftsize/2>=1
                init_row=c_row-fftsize/2;
                add_top=0;
            else
                init_row=1;
                add_top = 1-(c_row-fftsize/2);
            end
            if c_row+fftsize/2-1<=uSubNumWide*numSubPixel
                end_row = c_row+fftsize/2-1;
                add_bottom=0;
            else
                end_row=uSubNumWide*numSubPixel;
                add_bottom = c_row+fftsize/2-1-uSubNumWide*numSubPixel;
            end
            if c_col-fftsize/2>=1
                init_col=c_col-fftsize/2;
                add_left=0;
            else
                init_col=1;
                add_left = 1-(c_col-fftsize/2);
            end
            if c_col+fftsize/2-1<=uSubNumWide*numSubPixel
                end_col = c_col+fftsize/2-1;
                add_right=0;
            else
                end_col=uSubNumWide*numSubPixel;
                add_right = c_col+fftsize/2-1-uSubNumWide*numSubPixel;
            end
%             if sum([add_top add_bottom add_left add_right])>0
%                 amazing=1;
%             end
            I_total(init_row:end_row,init_col:end_col) = I_total(init_row:end_row,init_col:end_col)+arydSubI_temp(1+add_top:fftsize-add_bottom,1+add_left:fftsize-add_right);
         end
    end
end
if b_digital==1
    I_total = round(I_total/max(I_total(:))*(2^nBytes-1));
end

%[I_total,noise]=get_SNR(I_total,1000);
%I_total=imnoise(I_total, 'gaussian' , 0, 0.02 );
 %imshow(I_total);
I_total=mat2gray(I_total);

% I_total1  = Normalize(I_total )
[n,m]=size( I_total);
use_bg = 0;
npixsmall =0;
strel_rad =4;
radius = 10;
bw = imbinarize( I_total);
%bw = im2bw( I_total,0.8);

%% remove small objects
bw = bwareaopen(bw, npixsmall);
se = strel('disk',strel_rad);%���ɰ뾶Ϊstrel_rad��Բ
bw = imclose(bw, se);%
figure
    imshow(bw);
cc = bwconncomp(bw, 4);%�ҳ�������ͨ��
s = regionprops(cc, 'Centroid');%ÿ�����������
nspots = length(s);
hold on;
c=zeros(nspots,2);
for k = 1:nspots
    c1= s(k).Centroid;
    c(k,:)=c1(:,:);
    
    %plot(c(1), c(2), 'ro');
end
 c=sortrows(c);
c= Rearrange(c,aryuValueAry);
quaregrid = zeros(nspots, 4);
for k=1:nspots
   % c = s(k).Centroid;

   c2= round(c(k,:));
    minx = c2(1) - radius;
    maxx = c2(1) + radius;
    miny = c2(2) - radius;
    maxy = c2(2) + radius;

    box = [minx, maxx, miny, maxy];
    squaregrid(k, :) = box;
    %sfigure(6);
       hold on;
       rectangle('Position', [minx, miny, maxx-minx+1, maxy-miny+1], ...
            'LineWidth', 1, 'EdgeColor', 'w');
%    
%     subsfigure = I_total(box(3):box(4), box(1):box(2));
   % imshow(subsfigure);
     pause(0.01);
end
shstruct.nspots = nspots;
% [minx, miny, maxx-minx+1, maxy-miny+1]
% image plot coords
shstruct.squaregrid = squaregrid;
 move = shwfs_get_centres( I_total, shstruct);
 arydSubCentroidX=move(:,1);
 arydSubCentroidY=move(:,2);

for uRow = 1 : uSubNumWide
    for uColumn = 1 : uSubNumWide
        if aryuValueAry(uRow, uColumn) == 1 %�ڳ��ӿ׾���ǰ
            %�����ӿ׾�Զ���������
            arydSubI = I_total((uRow-1)*numSubPixel+1:uRow*numSubPixel,(uColumn-1)*numSubPixel+1:uColumn*numSubPixel);
            arydSubCentroidX1(uRow, uColumn) = sum(sum(arydSubI .* c_x)) / sum(sum(arydSubI));
            arydSubCentroidY1(uRow, uColumn) = sum(sum(arydSubI .* c_y)) / sum(sum(arydSubI));
        end
    end
end
end
