% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Pass through the 4f Fourier system to get the camera image
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear, clc
tic
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%% Convolution to get the image of microscope  %%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% STR = load('bead200nm8500_sf20nm.mat');
% OTF = double(STR.otf_bead);
% OTF_s2 = imread('dollar.bmp');
% OTF_s2 = double(OTF_s2);
% STR = load('PSF8500_sf2um.mat');
% PSF = STR.PSF_res;
% 
% disp('Convoluting PSF with OTF......')
disp('Loading PSF with OTF......')
% Img = conv2(OTF,PSF,'same');
STR = load('bead_img200nm8500_sf2um.mat');
Img = STR.Img;
Img_0 = Img/max(max(Img));
% figure(1),
% subplot(1,2,1),imshow(OTF);
% subplot(1,2,2),imshow(Img);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ================================================
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fourier Transform ONE
toc
disp('Fourier Trans - 1 ......')
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

field = Img;
ft1 = fftshift(fft2(fftshift(field)));
ftImg1 = abs(ft1).^2;
ftImg1 = ftImg1/max(max(ftImg1));
% figure(1000),imshow(ftImg1);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SLM pattern setting
toc
disp('SLM pattern setting ......')
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STR = load('slm06041004.mat');
% slm = STR.masking_0;

Rav1 = 1500;         dR1 = 500;
Rav2 = 3000;         dR2 = 1000;            % unit = um
% *********************************
R1 = Rav1-dR1/2;
R2 = Rav1+dR1/2;
R3 = Rav2-dR2/2;
R4 = Rav2+dR2/2;
magnitude = 1;
pxx=1920;
pxy=1080;
x = linspace(-pxx*8/2,pxx*8/2,pxx);
y = linspace(-pxy*8/2,pxy*8/2,pxy);
[X,Y] = meshgrid(x,y);
rho = sqrt((X*magnitude).^2+(Y*magnitude).^2);
slm = (rho>=R1).*(rho<=R2)+(rho>=R3).*(rho<=R4);
tA = zeros(size(Img,1),size(Img,2));
tA(ceil(1+(size(tA,1)-size(slm,1))/2):ceil((size(tA,1)+size(slm,1))/2),...
    ceil(1+(size(tA,2)-size(slm,2))/2):ceil((size(tA,2)+size(slm,2))/2)) =slm;
    
% figure(8),imshow(tA);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fourier Transform TWO
toc
disp('Fourier Trans - 2 ......')
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ft2 = fftshift(fft2(fftshift(ft1.*tA)));
ftImg2 = abs(ft2).^2;
ftImg2 = ftImg2/max(max(ftImg2));
% figure(2000),imshow(ftImg2);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure(5000),
% subplot(2,2,1),imshow(OTF);title('Bead');
% subplot(2,2,2),imshow(Img);title('Img of Bead');
% subplot(2,2,3),imshow(ftImg1);title('After the 1st FT');
% subplot(2,2,4),imshow(ftImg2);title('After the 2nd FT');
% imshow([OTF,Img;ftImg1,ftImg2])
% mesh(ftImg2(2000:2250,2000:2250));

%% %%%%%%%% Gaussian Fitting %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
toc
disp('Gaussian fitting ......')
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xcut = (4101:1:4400)*20-4100*20;
ycut = (4101:1:4400)*20-4100*20;
[Xcut,Ycut] = meshgrid(xcut,ycut);
Img_cut = Img_0(4101:1:4400,4101:1:4400);
ftImg2_cut = ftImg2(4101:1:4400,4101:1:4400);

Img_1d = Img_cut(151,:);
ftImg2_1d = ftImg2_cut(151,:);

Gauss2Mod1 = @(P,X0,k,x)...      % P is related to the size of the peak, greater->narrower
    max(max(Img_1d)).*exp( -1./P.*((x-X0).^2))+k;

Gauss2Mod2 = @(P,X0,k,x)...      % P is related to the size of the peak, greater->narrower
    max(max(ftImg2_1d)).*exp( -1./P.*((x-X0).^2))+k;

StartP1 = [500,150*20,min(Img_1d)];
StartP2 = [300,150*20,min(ftImg2_1d)];

% DataFit=[reshape(Xcut,[],1),reshape(Ycut,[],1),reshape(Img_cut,[],1),reshape(ftImg2_cut,[],1)];
DataFit=[xcut',Img_1d',ftImg2_1d'];
[GasFit1,GOF1] = fit(DataFit(:,1),DataFit(:,2),Gauss2Mod1,'StartPoint',StartP1);
Fitted1 = reshape(GasFit1(DataFit(:,1)),size(xcut'));
Eff1 = coeffvalues(GasFit1);

[GasFit2,GOF2] = fit(DataFit(:,1),DataFit(:,3),Gauss2Mod2,'StartPoint',StartP2);
Fitted2 = reshape(GasFit2(DataFit(:,1)),size(xcut'));
Eff2 = coeffvalues(GasFit2);

disp(GasFit1)
disp(GasFit2)

figure(200),
% subplot(1,2,1),
scatter(xcut,Img_1d);
hold on
plot(xcut,Fitted1);
title(['Gaussian | FWHM = ',num2str(2*sqrt(log(2)*Eff1(1)))])
hold off

figure(201)
% subplot(1,2,2),
scatter(xcut,ftImg2_1d);
hold on
plot(xcut,Fitted2);
title(['Double | FWHM = ',num2str(2*sqrt(log(2)*Eff2(1)))])
% title(['Single-ring(Outer) | FWHM = ',num2str(2*sqrt(log(2)*Eff2(1)))])
% title(['Single-ring(Inner) | FWHM = ',num2str(2*sqrt(log(2)*Eff2(1)))])
hold off

% figure(2),
% imshow([Img_cut,ftImg2_cut])

%% END
toc