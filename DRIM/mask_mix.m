clear,clc
parameters = [1500,500,3000,1000];
period = 60;
lambda = 680e-9;
z0=30e-3;
dx=0;
dy=0;
mask1 = MaskFunc( parameters,period,lambda,-z0,dx,dy );
mask2 = MaskFunc( parameters,period,lambda,0,dx,dy );
mask3 = MaskFunc( parameters,period,lambda,z0,dx,dy );

pxx=1920;
pxy=1080;
% x = linspace(1,pxx,pxx);
% y = linspace(1,pxy,pxy);
% [X,Y] = meshgrid(x,y);

A = rand(pxy,pxx);
A1 = (A<=1/3);
A2 = (A>1/3).*(A<=2/3);
A3 = (A>2/3);
mask = mask1.*A1 + mask2.*A2 + mask3.*A3;

figure(200),
subplot(221),imshow(mask1);
subplot(222),imshow(mask2);
subplot(223),imshow(mask3);
subplot(224),imshow(mask);

% figure(300),imshow(mask1.*A1+mask3.*A3)