%%%%%%%���N�׵�zernik����ʽz���뾶���õ�λԲ��һ����SnΪ��������������zernik����ʽ����ʽ��д
%%%%%%created by huangjian
function z=zernike(mode,Na)
[n m]=nmzern(mode);%�ɽ״�modeȷ����Ƶ��m,n
x=linspace(-1,1,Na);%���Բ���
y=x;
[x,y]=meshgrid(x,y);%�����������
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
% z=z.*Pupil(Na);%PupilΪԲ��ضϺ���
% z(z==0)=0;%���Ҫ��뾶��ֵΪ0����NaN��Ϊ0����