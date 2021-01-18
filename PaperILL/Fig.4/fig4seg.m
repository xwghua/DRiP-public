clear,clc
im0 = imread('full\mitodr40glowmapgamma.tif');
im = imread('full\mitogasr15gamma.tif');

imseg1 = im(34:166,328:460,:);
im0seg1 = im0(34:166,328:460,:);
% imseg2 = im(89:221,470:602,:);
% im0seg2 = im0(89:221,470:602,:);

figure(1),
subplot(121),imshow(im0seg1);
subplot(122),imshow(imseg1);
% subplot(223),imshow(im0seg2);
% subplot(224),imshow(imseg2);
%% ========================
immk = im;
im0mk = im0;

% im0mk(87:88,469:603,1:2) = 255;
% im0mk(222:223,469:603,1:2) = 255;
% im0mk(88:222,468:469,1:2) = 255;
% im0mk(88:222,603:604,1:2) = 255;
% immk(87:88,469:603,1:2) = 255;
% immk(222:223,469:603,1:2) = 255;
% immk(88:222,468:469,1:2) = 255;
% immk(88:222,603:604,1:2) = 255;

im0mk(31:33,325:463,1:2) = 255;
im0mk(167:169,325:463,1:2) = 255;
im0mk(31:169,325:327,1:2) = 255;
im0mk(32:169,461:463,1:2) = 255;
immk(31:33,325:463,1:2) = 255;
immk(167:169,325:463,1:2) = 255;
immk(31:167,325:327,1:2) = 255;
immk(31:167,461:463,1:2) = 255;

figure(2)
subplot(211),imshow(im0mk);
subplot(212),imshow(immk);
%%
imwrite(im0mk,'seg\mitodr40glowmk.tif')
imwrite(immk,'seg\mitogasr15mk.tif')
imwrite(im0seg1,'seg\mitodr40glowseg1.tif')
% imwrite(im0seg2,'seg\mitodr40glowseg2.tif')
imwrite(imseg1,'seg\mitogasr15seg1.tif')
% imwrite(imseg2,'seg\mitogas515seg2.tif')