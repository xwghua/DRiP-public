clear,clc

for i = 1:41
    im1(:,:,i) = double(imread('tmGAU.tif',i+9));
    
    
    im2(:,:,i) = double(imread('tmDRiP.tif',i+9));
    
    
    im3(:,:,i) = double(imread('tmIR.tif',i+9));
    
    
    im4(:,:,i) = double(imread('tmOR.tif',i+9));
end

im1 = im1/max(max(max(im1)))*255;
im2 = im2/max(max(max(im2)))*255;
im3 = im3/max(max(max(im3)))*255;
im4 = im4/max(max(max(im4)))*255;
%%
im11 = im1(:,:,1);im21 = im2(:,:,1);im31 = im3(:,:,1);im41 = im4(:,:,1);

im12 = im1(:,:,11);im22 = im2(:,:,11);im32 = im3(:,:,11);im42 = im4(:,:,11);

im13 = im1(:,:,21);im23 = im2(:,:,21);im33 = im3(:,:,21);im43 = im4(:,:,21);

im14 = im1(:,:,31);im24 = im2(:,:,31);im34 = im3(:,:,31);im44 = im4(:,:,31);

im15 = im1(:,:,41);im25 = im2(:,:,41);im35 = im3(:,:,40);im45 = im4(:,:,41);

imwrite(uint8(im11),hot(255),'mt\im11.tif');imwrite(uint8(im21),hot(255),'mt\im21.tif');imwrite(uint8(im31),hot(255),'mt\im31.tif');imwrite(uint8(im41),hot(255),'mt\im41.tif');
imwrite(uint8(im12),hot(255),'mt\im12.tif');imwrite(uint8(im22),hot(255),'mt\im22.tif');imwrite(uint8(im32),hot(255),'mt\im32.tif');imwrite(uint8(im42),hot(255),'mt\im42.tif');
imwrite(uint8(im13),hot(255),'mt\im13.tif');imwrite(uint8(im23),hot(255),'mt\im23.tif');imwrite(uint8(im33),hot(255),'mt\im33.tif');imwrite(uint8(im43),hot(255),'mt\im43.tif');
imwrite(uint8(im14),hot(255),'mt\im14.tif');imwrite(uint8(im24),hot(255),'mt\im24.tif');imwrite(uint8(im34),hot(255),'mt\im34.tif');imwrite(uint8(im44),hot(255),'mt\im44.tif');
imwrite(uint8(im15),hot(255),'mt\im15.tif');imwrite(uint8(im25),hot(255),'mt\im25.tif');imwrite(uint8(im35),hot(255),'mt\im35.tif');imwrite(uint8(im45),hot(255),'mt\im45.tif');

%%
% subim1 = im13(162:221,426:485);%imshow(subim1);
% subim2 = im23(162:221,426:485);%imshow(subim2);
% subim3 = im33(162:221,426:485);%imshow(subim3);
% subim4 = im43(162:221,426:485);%imshow(subim4);
% 
% diag13 = double(diag(fliplr(subim1)));
% diag23 = double(diag(fliplr(subim2)));
% diag33 = double(diag(fliplr(subim3)));
% diag43 = double(diag(fliplr(subim4)));
% 
% imwrite(subim1,'mt\subim1.tif');
% imwrite(subim2,'mt\subim2.tif');
% imwrite(subim3,'mt\subim3.tif');
% imwrite(subim4,'mt\subim4.tif');
% 
% diag13 = (diag13-min(diag13)) ./ (max(diag13)-min(diag13)) .*255;
% diag23 = (diag23-min(diag23)) ./ (max(diag23)-min(diag23)) .*255;
% diag33 = (diag33-min(diag33)) ./ (max(diag33)-min(diag33)) .*255;
% diag43 = (diag43-min(diag43)) ./ (max(diag43)-min(diag43)) .*255;
%%
% subim5 = im13(220:279,226:285);%imshow(subim1);
% subim6 = im23(220:279,226:285);%imshow(subim2);
% subim7 = im33(220:279,226:285);%imshow(subim3);
% subim8 = im43(220:279,226:285);%imshow(subim4);
% 
% diag53 = double(diag(fliplr(subim5)));
% diag63 = double(diag(fliplr(subim6)));
% diag73 = double(diag(fliplr(subim7)));
% diag83 = double(diag(fliplr(subim8)));
% 
% imwrite(subim5,'mt\subim5.tif');
% imwrite(subim6,'mt\subim6.tif');
% imwrite(subim7,'mt\subim7.tif');
% imwrite(subim8,'mt\subim8.tif');
% 
% diag53 = (diag53-min(diag53)) ./ (max(diag53)-min(diag53)) .*255;
% diag63 = (diag63-min(diag63)) ./ (max(diag63)-min(diag63)) .*255;
% diag73 = (diag73-min(diag73)) ./ (max(diag73)-min(diag73)) .*255;
% diag83 = (diag83-min(diag83)) ./ (max(diag83)-min(diag83)) .*255;

%%

diag1 = diag(fliplr(im11))+diag(fliplr(im12))+diag(fliplr(im13))+diag(fliplr(im14))+diag(fliplr(im15));
diag2 = diag(fliplr(im21))+diag(fliplr(im22))+diag(fliplr(im23))+diag(fliplr(im24))+diag(fliplr(im25));
diag3 = diag(fliplr(im31))+diag(fliplr(im32))+diag(fliplr(im33))+diag(fliplr(im34))+diag(fliplr(im35));
diag4 = diag(fliplr(im41))+diag(fliplr(im42))+diag(fliplr(im43))+diag(fliplr(im44))+diag(fliplr(im45));

diag1 = diag1/max(diag1);
diag2 = diag2/max(diag2);
diag3 = diag3/max(diag3);
diag4 = diag4/max(diag4);

figure(1),
x = linspace(0,512*40/1000*sqrt(2),512);
plot(x,diag1,'LineWidth',2),
hold on
plot(x,diag2,'LineWidth',2),plot(x,diag3,'LineWidth',2),plot(x,diag4,'LineWidth',2),
xlabel('Diagonal in x-y dimension (\mum)','FontSize',18)
ylabel('Nomalized intensity','FontSize',18)
legend({'GAU','DRiP','IR','OR'},'FontSize',18)
axis tight