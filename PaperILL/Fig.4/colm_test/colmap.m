%% This program is for colormap designing and correcting
clear
clc
im = imread('mitodr0.tif');
im = double(im);
im = im/max(im(:));
clm0 = gray(256);
clm = gray(256);
k0 = 40;
x0 = 47;
% -----------
k1 = 35;
x1 = 83;
% -----------
k2 = 15;
x2 = 135;
% -----------
k3 = 12;
x3 = 210;

clm = (0.8./(1+exp(-k0*(clm-x0/256)))+0.6./(1+exp(-k1*(clm-x1/256)))...
    +1.5./(1+exp(-k2*(clm-x2/256)))+1.5./(1+exp(-k3*(clm-x3/256))));
clm = (clm-min(clm(:)))/(max(clm(:))-min(clm(:)));
% clm = clm-min(clm(:));

% figure(1),plot(clm(:,1));

figure(2),
subplot(221),plot(clm0(:,1)),hold on,plot(clm(:,1)),hold off,title('modified colormap');
subplot(222),plot(clm0(:,1)),title('original colormap');
subplot(223),imshow(uint8(255*im),clm),title('unchanged data with modified colormap');
subplot(224),imshow(uint8(255*im),gray(256)),title('unchanged data with original colormap');
%%
% imcol = ind2rgb(uint8(255*im),clm);
% figure(3),imshow(imcol)
% imwrite(imcol,'mitodr0map.tif')