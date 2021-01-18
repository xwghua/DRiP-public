function [ imgout ] = adjjj( imgname,adjscale )
%ADJJJ Summary of this function goes here
%   Detailed explanation goes here

imgin = double(imread(imgname));
imgmid0 = imgin/max(imgin(:));
imgmid1 = [];
imgmid2 = [];
for i = 1:5
    imgmid1 = cat(1,imgmid1,imgmid0*0.2*i);
    imgmid2 = cat(1,imgmid2,imgmid0*(0.2*i+1));
end
imgmid = cat(2,imgmid1,imgmid2);
figure,imshow(imgmid);

imgout = imgin/max(imgin(:)) * adjscale;
figure,imshow(imgout);
end

