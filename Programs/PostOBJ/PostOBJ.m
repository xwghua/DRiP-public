% *********************************************************************
% This program aims to generate the PSF image
%
% AFTER "OBJECTIVE & TUBE LENS"
%
% *********************************************************************
clear,clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

scale = 4250.0/1700;
x = linspace(-850*scale,850*scale,1700*scale);
y = linspace(-850*scale,850*scale,1700*scale);
[X,Y] = meshgrid(x,y);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x1 = x*1E-6;
x2 = y*1E-6;
p1 = 0;
p2 = 0;
% p3 = -2*1e-6;

fobj = 2E-3;
NA = 1.45;

lambda = 680E-9;
M = 100;
n = 1.515;
% center = ceil(length(x)/4+1):1:ceil(length(x)/4*3);
center = 1:1:ceil(length(x)/4*3);

PSF_OBJ_3D = [];
PSF_OBJ_3D_opt = [];
for p3 = -5e-7%-2e-6:1e-7:0e-6
    disp(['Xuanwen | P3: ',num2str(p3),', end is 2e-6, interval 1e-7'])
%     PSF_OBJ = calcPSF(p1,p2,p3,fobj,NA,x1,x2,lambda,M,n,center);
%     PSF_OBJ_int = abs(PSF_OBJ).^2;
%     PSF_OBJ_3D = cat(3,PSF_OBJ_3D,PSF_OBJ_int);
%     PSF_OBJ_3D = PSF_OBJ_3D/max(max(PSF_OBJ_3D));
    
    [PSF_OBJ_opt,gkx,gkw1] = calcPSF_opt(p1,p2,p3,fobj,NA,x1,x2,lambda,M,n,center);
    params = [gkx',gkw1'];
    PSF_OBJ_int_opt = abs(PSF_OBJ_opt).^2;
    PSF_OBJ_3D_opt = cat(3,PSF_OBJ_3D_opt,PSF_OBJ_int_opt);
    PSF_OBJ_3D_opt = PSF_OBJ_3D_opt/max(max(PSF_OBJ_3D_opt));
end

% err_PSF = PSF_OBJ_3D_opt/max(max(PSF_OBJ_3D_opt)) - PSF_OBJ_3D/max(max(PSF_OBJ_3D));

% err_PSF = PSF_OBJ_3D_opt - PSF_OBJ_3D;

% figure,
% subplot(131),mesh(PSF_OBJ_3D);
% subplot(132),mesh(PSF_OBJ_3D_opt);
% subplot(133),mesh(err_PSF);

% save('PSF_OBJ_3D_1.mat','PSF_OBJ_3D')
% 
% PSF_OBJ_3D = [];
% for p3 = 0.1e-6:1e-7:2e-6
%     disp(['Xuanwen | P3: ',num2str(p3),', end is 2e-6, interval 1e-7'])
%     PSF_OBJ = calcPSF(p1,p2,p3,fobj,NA,x1,x2,lambda,M,n,center);
%     PSF_OBJ_int = abs(PSF_OBJ).^2;
%     PSF_OBJ_3D = cat(3,PSF_OBJ_3D,PSF_OBJ_int);
% end
% save('PSF_OBJ_3D_2.mat','PSF_OBJ_3D')

% PSF_OBJ_norm = PSF_OBJ_int/max(PSF_OBJ_int(:))*255;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure(100)
% imshow(uint8(PSF_OBJ_norm))
% figure,imshow(PSF_OBJ/max(max(PSF_OBJ)));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
