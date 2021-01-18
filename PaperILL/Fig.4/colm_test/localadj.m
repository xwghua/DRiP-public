clear
clc
im = imread('mitogasr15.tif');
% lower = 30;
% upper=60;

% for i = 1:size(im,1)
%     for j = 1:size(im,2)
%         judger = (im(i,j,1)>lower)*(im(i,j,2)>lower)*(im(i,j,3)>lower)*...
%             (im(i,j,1)<upper)*(im(i,j,2)<upper)*(im(i,j,3)<upper);
%         if judger==1
%             im(i,j,:) = im(i,j,:)+(80-mean(im(i,j,:)));
%         end
%     end
% end
imj = imadjust(im,[10/255 255/255],[],0.65);
figure(1),imshowpair(im,imj,'montage');
%%
% imwrite(imj,'mitodr0glowmapgamma.tif')