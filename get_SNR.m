%给灰度图像添加指定信噪比的噪声https://blog.csdn.net/khqxf/article/details/104118098
%先计算信号的功率,再获得噪声的功率,然后生成一个标准高斯分布（均值为0，标准差为1）
%的噪声序列（和信号长度一样）,再通过转换得到我们最终想要的高斯噪声.
function [X1_noise,noise]=get_SNR(X,SNR)
% X：原灰度图像,使用imread读入
% SNR：指定的信噪比
% X1_noise:添加噪声后的图像
% noise：所添加的噪声
X1=im2double(X); %只针对图像，可以换成X1=double(X)/255; 
%figure;imshow(X1)
[m,n]=size(X1);
noise=randn(m,n);
noise=noise-mean2(noise);  %均值为0，方差接近1

avg1=mean2(X1);
s1=0;
for i = 1:m
    for j = 1:n
        s1 = s1+(X1(i,j)-avg1)^2;
        %s1 = s1+X(i,j)^2;  %未考虑去除均值
    end
end
signal_power=s1/(m*n);%信号平均功率
noise_variance=signal_power*10^(-SNR/10);
noise=sqrt(noise_variance)/std2(noise)*noise;  %期望的噪声
X1_noise=X1+noise; %得到指定信噪比的灰度图像
%figure;imshow(X1_noise)
return

