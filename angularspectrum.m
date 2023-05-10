function [img]=angularspectrum(obj,totalsizex,totalsizey,z,lambda)
k=2*pi/lambda;
[pixelx,pixely]=size(obj);
originpoint=ceil((pixelx+1)/2);
dfx=1/totalsizex;
dx=(1-originpoint:pixelx-originpoint)*dfx;
originpoint=ceil((pixely+1)/2);
dfy=1/totalsizey;
dy=(1-originpoint:pixely-originpoint)*dfy;
[dx,dy]=meshgrid(dx,dy);
fobj=fftshift(fft2(fftshift(obj)));
H=fobj.*exp(1j*k*z*sqrt(1-(lambda*dx).^2-(lambda*dy).^2));
img=fftshift(ifft2(fftshift(H)));
end

