% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Desample the PSF
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear,clc
STR = load('PSF8500_sf1um_3D.mat');
PSF_3D = STR.PSF_OBJ;
sf0 = 1; % um
sf1 = 2; % um

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% scale = 1;
% PSF = imresize(PSF,scale);
PSF_qt = PSF(1:ceil(size(PSF,1)/2),1:ceil(size(PSF,2)/2),:);

row = size(PSF_qt,1);
clm = size(PSF_qt,2);

% PSF_res_qt = zeros(ceil(size(PSF,1)/scale/sf1/2),ceil(size(PSF,2)/scale/sf1/2));
PSF_res_qt = [];
% row_res = size(PSF_res_qt,1);
% clm_res = size(PSF_res_qt,2);

for i = row:-(scale*sf1):1
    PSF_res_line = [];
    for j = clm:-(scale*sf1):1
       PSF_res_line = cat(2,PSF_qt(i,j,:),PSF_res_line); 
    end
    PSF_res_qt = cat(1,PSF_res_line,PSF_res_qt);
end
PSF_res_qt = cat(1,cat(2,zeros(size(PSF,1)/scale/2-size(PSF_res_qt,1),size(PSF,2)/scale/2-size(PSF_res_qt,2)),...
    zeros(size(PSF,1)/scale/2-size(PSF_res_qt,1),size(PSF_res_qt,2))),...
    cat(2,zeros(size(PSF_res_qt,1),size(PSF,2)/scale/2-size(PSF_res_qt,2)),PSF_res_qt));

PSF_res_hf = [PSF_res_qt,fliplr(PSF_res_qt)];
PSF_res = [PSF_res_hf;flipud(PSF_res_hf)];


figure,
subplot(1,2,1),imshow(STR.PSF_OBJ);
subplot(1,2,2),imshow(PSF_res);