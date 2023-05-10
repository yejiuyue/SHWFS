function SNR=check_SNR(signal,noise)
% signal:原灰度图像,使用imread读入
% noise：噪声
signal=im2double(signal); %归一化到0~1之间,可以换成signal=double(signal)/255;
[m,n]=size(signal);
avg1=mean2(signal);
s1=0;
for i = 1:m
    for j = 1:n
        s1 = s1+(signal(i,j)-avg1)^2;
        %s1 = s1+signal(i,j)^2;
    end
end
signal_power=s1/(m*n); %信号平均功率

[m1,n1]=size(noise);
avg2=mean2(noise);
s2=0;
for i = 1:m1
    for j = 1:n1
        s2 = s2+(noise(i,j)-avg2)^2;
        % s2 = s2+noise(i,j)^2;
    end
end
noise_power=s2/(m1*n1); %噪声功率

SNR=10*log10(signal_power/noise_power);
return

