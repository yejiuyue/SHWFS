%%%%%%%求第N阶的zernik多项式z，半径采用单位圆规一化，Sn为采样点数，根据zernik多项式定义式编写
%%%%%%created by huangjian
function z=zernike(mode,Na)
[n m]=nmzern(mode);%由阶次mode确定角频率m,n
x=linspace(-1,1,Na);%线性采样
y=x;
[x,y]=meshgrid(x,y);%建立万个矩阵
[p,q]=size(x);
r=sqrt(x.^2+y.^2);
th=atan2(y,x);
s=0;
R=0;
while (s>=0)&&(s<=(n-m)/2)
    a=(-1)^s*factorial((n-s));
    b=factorial(s)*factorial(((n+m)/2-s))*factorial(((n-m)/2-s));
    k=a/b;
    R=R+k.*r.^(n-2*s);
    s=s+1;
end
if m==0
    z=sqrt(n+1)*R;
else if mod(mode,2)==0
        z=sqrt(2*(n+1))*R.*cos(m*th);
    else
        z=sqrt(2*(n+1))*R.*sin(m*th);
    end
end
% z=z.*Pupil(Na);%Pupil为圆域截断函数
% z(z==0)=0;%如果要求半径外值为0，将NaN改为0即可