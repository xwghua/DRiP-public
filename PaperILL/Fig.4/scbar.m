clear,clc
im = imread('seg\mitogas115colseg1ori.tif');
im(end-16:end-15,end-30:end-11,:) = 255;
figure(1),imshow(im);
imwrite(im,'seg\mitogas115colseg1.tif');