im = imread('mt_1.tif');
% figure(1),imshow(im);
im2 = im;
im2(1:320,1:270) = 0;
im2(220:320,220:320)=0;
% figure,imshow(im2);
im3 = im - im2;
% figure,imshow(im3);
im4 = imrotate(im3,90);
% figure,imshow(im4);
% im4 = flipud(im3);
% figure,imshow(im4);

mt3d = zeros(512,512,60);
mt3d(:,:,21) = im3;
% mt3d(:,:,90) = im2;
mt3d(:,:,30) = im2;
mt3d(:,:,40) = im4;

for i = 1:60
   imwrite(mt3d(:,:,i),'mt3d.tif','WriteMode','append') 
end