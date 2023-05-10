function[outpsf1 ]=propagpectrum(u,detal,lambda,z,flength)
%Created by Sergio Bonaque-Gonzalez. Optical Engineer.
%   sergio.bonaque@um.es
% This function calculates the propagation in the Fresnel regime. The transfer function assumes an uniform sampling. 


%INPUTS:
% u1 - Origin field
% L1 - Length of the side of the source 
% lambda - wavelength in meters
% z - propagation distance in meters. 
%contador= dummy variable which indicates if a message should be showed or not

%OUTPUTS:
% L2 - Length of the side of the observed field.  
% u2 - observed field

[M,~]=size(u); 
L=detal.*(M-1);
dx=L/M; 

%crit = abs(lambda*z/L);

k=2*pi/lambda;
% 
%     if dx > crit
%         disp('Propagation in Fresnel regime was succesful!');
%     else
%         disp('Insufficient sampling');
%     end
x=-0.5*L:dx:0.5*L-dx;
%L2=2*L;   
% L2=lambda*z/dx;
% dx2=L2/M;          
% x2=-L2/2:dx2:L2/2-dx2;   
fex=1/dx;
i=sqrt(-1);
[X2,Y2]=meshgrid(x,x); 
u1=u.*exp(-i*k*(X2.^2+Y2.^2)./(2*flength));
fx=[-fex/2:fex/M:fex/2-fex/M];%freq coords 
[FX,FY]=meshgrid(fx,fx); 

H=exp(1i*k*z*sqrt(1-(lambda*FX).^2-(lambda*FY).^2)); %trans func.  The exp(jkz) term is ignored. This term doesnst affect the transverse spatial structure of the observation plane result.
%H=fftshift(H); %shift trans func 
U1=fftshift(fft2(fftshift(u1))); %shift, fft src field 
U2=H.*U1; %multiply 
u2=fftshift(ifft2(fftshift(U2))); %inv fft, center obs field 
outpsf1= u2.*conj(u2);
%outpsf1 = imresize(outpsf0,2,'bilinear');
end

