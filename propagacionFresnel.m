function[outpsf1 ]=propagacionFresnel(u1,L,lambda,z)
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

[M,~]=size(u1); 
dx=L/M; 
crit = abs(lambda*z/L);


    if dx > crit
        disp('Propagation in Fresnel regime was succesful!');
    else
        disp('Insufficient sampling');
    end
k=2*pi/lambda;
L2      = lambda*z/dx;% 像面尺寸,0.78um*10mm/10um=780mm
dx2     = lambda*z/L; % 像面的最小尺寸,0.78um*10mm/300um=26um
x2      = -L2/2:dx2:L2/2-dx2;%  -390nm:26nm:364.4nm, 50等分
[X2,Y2] = meshgrid(x2,x2); 
c       = 1/(1i*lambda*z)*exp(1i*k/(2*z)*(X2.^2+Y2.^2)); % 系数
u2      = c.*ifftshift(fft2(fftshift(u1)))*dx^2;
outpsf0  =  abs(u2).^2;
%outpsf1 = imresize(outpsf0,2,'bilinear');
end
