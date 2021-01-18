
% IM_3D creates a solid, 3D image of multiple slices. First, create a 
% string of the directory name of the files (DIRECT1) and a cell of the 
% .png filenames (FILES). All files must be the same dimensions and must be 
% in the order from lowest slice to highest slice. 
%
%   example:
%       direct1='~/webMill/2011-08-18/region4/images/';
%       files=
%           'Result_7481_sub13755.0_vol3.0_sl28_rater27_tutfalse.png'
%           'Result_22495_sub13755.0_vol3.0_sl29_rater57_tutfalse.png'
%           'Result_42271_sub13755.0_vol3.0_sl30_rater32_tutfalse.png'
%           'Result_30727_sub13755.0_vol3.0_sl31_rater83_tutfalse.png'
%       im_3d(direct2,files)
 
%function im_3d(direct1,files)
 direct1='slices34\';
c=length(imread([direct1 '1.tif'])); %finds dimensions of the matrix of the image
 
x=double(zeros(c,c,800)); %creates a zeros 3D matrix
 
for iii=1:800
    x(:,:,iii)=imread([direct1 num2str(iii) '.tif']); %puts each slice into matrix
end
 
z=smooth3(x);
isosurface(z) %creates 3D image 
patch(isocaps(z,2),'Edgecolor','blue');
brighten(1)
light