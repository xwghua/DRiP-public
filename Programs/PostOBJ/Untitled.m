clc;  
clear all;  
close all;  
  
% input a character, and save to bitmap   
set(gca, 'xtick', [], 'ytick', []);   
axis off;    
%in this example, the character is w  
text(0, 0, '\fontsize{60}hello', 'color', 'black' );   
saveas(gcf, 'tmp','jpg');  
  
im = imread('tmp.jpg');  
im = 255-rgb2gray(im);  
imshow(im)

% imx = imcrop(im, [150 730 150 150]);  
% imshow(imx);  title('imx crop');