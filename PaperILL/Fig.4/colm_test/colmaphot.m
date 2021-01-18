%% This program is for colormap designing and correcting
clear
clc
im = imread('mitodr0.tif');
im = double(im);
im = im/max(im(:));
clm0 = hot(256);
clm = hot(256);
k10 = 15;   k20 = 12;   k30 = 10;
x10 = 135;   x20 = 10;   x30 = 20;  
% -----------
k11 = 8;   k21 = 8;   k31 = 10;
x11 = 200;  x21 = 120;   x31 = 128;
% -----------
k12 = 8;   k22 = 10;   k32 = 10;
x12 = 230;  x22 = 200;   x32 = 220;
% -----------
% k3 = 12;
% x3 = 210;

clm(:,1) = 0.75./(1+exp(-k10*(clm(:,1)-x10/256)))+1./(1+exp(-k11*(clm(:,1)-x11/256)))+0.5./(1+exp(-k12*(clm(:,1)-x12/256)));
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
% imwrite(imcol,'mitodr0map.tif')