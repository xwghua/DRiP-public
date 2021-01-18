%% This is a program for generating a mask with specific parameters
clc,clear

%% parameters
magnitude = 1;
% *********************************
Rav1 = 1500;         dR1 = 500;
Rav2 = 3000;         dR2 = 1000;
% *********************************
R1 = Rav1-dR1/2;
R2 = Rav1+dR1/2;
R3 = Rav2-dR2/2;
R4 = Rav2+dR2/2;
%% generating rings
pxx=1920;
pxy=1080;
x = linspace(-pxx*8/2,pxx*8/2,pxx);
y = linspace(-pxy*8/2,pxy*8/2,pxy);
[X,Y] = meshgrid(x,y);
% ==============================
dx = 0; % + left - right
dy = 0; % + up - down
% ==============================
rho = sqrt((X*magnitude+dx*8).^2+(Y*magnitude+dy*8).^2);
tA = (rho>=R1).*(rho<=R2)+(rho>=R3).*(rho<=R4);
%% generating grating peroids
n = 40;
grating = zeros(pxy,pxx);
for i = 1:1:pxy
    grating(i,:) = 1/1920/4*n*mod(x,1920*4/n);
    %     grating(i,:) = (mod(x,1920*4/n*2)>=1920*4/n);
end
%% chirp
lambda = 680e-9;
focus = 20e-2;
fsf = 8e-6;
z0 = 0e-3;
% [chirpX, chirpY] = meshgrid((-959:1:960)/(1920*4e-6),(-539:1:540)/(1080*4e-6));
[chirpX, chirpY] = meshgrid(((-959:1:960)+dx)/(lambda*focus/fsf),((-539:1:540)+dy)/(lambda*focus/fsf));
chirp_angle = sqrt(max(0,lambda^-2-chirpX.^2-chirpY.^2));
% chirp = exp(-1i*2*pi*chirp_angle*z0);
chirp_mask = -2*pi*chirp_angle*z0;
angle_total = (chirp_mask*256/2/pi-256*floor(chirp_mask/2/pi))/256;
%% combination
masking_0 = angle_total.*tA;
masking = (mod(grating+angle_total,1)).*tA;
%% ploting
% figure('toolbar','none','MenuBar','none','Position',[0,0,size(masking,2),size(masking,1)]),
% imshow(masking,'border','tight','initialmagnification','fit')
figure(1),
subplot(311),imshow(tA)
subplot(312),imshow(angle_total)
subplot(313),imshow(masking)

figure(2),
imshow(tA, 'border','tight','initialmagnification','fit');
set (gcf,'Position',[512,256,960,540])
%  imwrite(masking_0,'mask_shiftpos.bmp')