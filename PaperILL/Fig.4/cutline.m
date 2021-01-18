clear,clc
im = imread('seg\mitogas115colseg1.tif');
y = 3:1:130;
x = round((y+22)/2.3);
% 


figure(1),imshow(im,'border','tight','initialmagnification','fit');
set (gcf,'Position',[480,270,266,266]);
axis normal;
% hold on;
% plot(x,y,'y--','LineWidth',1.25);
% hold off;
%%
% cl = [];
% for i = 1:1:128
%         cl = cat(2,cl,im(y(i),x(i)));
% end
clear,clc
load('cl1.mat')
cl1 = cl;
load('cl2.mat')
cl2 = cl;
load('cl3.mat')
cl3 = cl;
load('cl4.mat')
cl4 = cl;
load('cl5.mat')
cl5 = cl;
load('cldr.mat')
cldr = cl;
figure(200),
plot(cl1,'--','LineWidth',1.25);
hold on;
plot(cl2,'--','LineWidth',1.25);
plot(cl3,'--','LineWidth',1.25);
plot(cl4,'--','LineWidth',1.25);
plot(cl5,'--','LineWidth',1.25);
plot(cl1+cl2+cl3+cl4+cl5,'-','LineWidth',1.25);
plot(cldr,'-','LineWidth',1.25);
columnlegend(2,{'z=-2\mum','z=-1\mum','z=0\mum','z=+1\mum','z=+2\mum','Gaussian scanning','DRiP Bessel'},'NorthWest');