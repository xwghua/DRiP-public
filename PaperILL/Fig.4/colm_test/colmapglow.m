%% This program is for colormap designing and correcting
clear
clc
load('glow.mat');
im = imread('mitodr40.tif');
% imglow = imread('mitodr0glow.tif');
im = double(im);
im = im/max(im(:));
clm = clm0;
k10 = 10;   k20 = 15;   k30 = 15;
x10 = 90;   x20 = 60;   x30 = 80;  
% -----------
k11 = 10;   k21 = 12;   k31 = 10;
x11 = 160;  x21 = 140;   x31 = 150;
% -----------
k12 = 10;   k22 = 12;   k32 = 13;
x12 = 220;  x22 = 220;   x32 = 230;
% -----------
% k3 = 12;
% x3 = 210;

clm(:,1) = 1./(1+exp(-k10*(clm(:,1)-x10/256)))+1./(1+exp(-k11*(clm(:,1)-x11/256)))+1./(1+exp(-k12*(clm(:,1)-x12/256)));
clm(:,2) = 1./(1+exp(-k20*(clm(:,2)-x20/256)))+1./(1+exp(-k21*(clm(:,2)-x21/256)))+1./(1+exp(-k22*(clm(:,2)-x22/256)));
clm(:,3) = 1./(1+exp(-k30*(clm(:,3)-x30/256)))+1./(1+exp(-k31*(clm(:,3)-x31/256)))+1./(1+exp(-k32*(clm(:,3)-x32/256)));

clm(:,1) = (clm(:,1)-min(clm(:,1)))/(max(clm(:,1))-min(clm(:,1)));
clm(:,2) = (clm(:,2)-min(clm(:,2)))/(max(clm(:,2))-min(clm(:,2)));
clm(:,3) = (clm(:,3)-min(clm(:,3)))/(max(clm(:,3))-min(clm(:,3)));
% clm = clm-min(clm(:));

% figure(1),plot(clm(:,1));

figure(2),
subplot(221),plot(clm0),hold on,plot(clm),hold off,title('modified colormap');
subplot(222),plot(clm0),title('original colormap');
subplot(223),imshow(uint8(255*im),clm),title('unchanged data with modified colormap');
subplot(224),imshow(uint8(255*im),clm0),title('unchanged data with original colormap');
%%
% imcol = ind2rgb(uint8(255*im),clm);
% figure(3),imshow(imcol)
% imwrite(imcol,'mitodr0glowmap.tif')