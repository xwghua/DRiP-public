% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Pass through the 4f Fourier system to get the camera image
% with multiple SLM patterns generated in .xlsx files
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear, clc

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%% Convolution to get the image of microscope  %%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

STR = load('bead110nm8500_sf20nm.mat');
OTF = double(STR.otf_bead);
% OTF_s2 = imread('dollar.bmp');
% OTF_s2 = double(OTF_s2);
STR = load('PSF8500_sf2um.mat');
PSF = STR.PSF_res;

disp('Convoluting PSF with OTF......')
Img = conv2(OTF,PSF,'same');
Img = Img/max(max(Img));
% figure(1),
% subplot(1,2,1),imshow(OTF);
% subplot(1,2,2),imshow(Img);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ================================================
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fourier Transform ONE
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
field = Img;
ft1 = fftshift(fft2(fftshift(field)));
ftImg1 = abs(ft1).^2;
ftImg1 = ftImg1/max(max(ftImg1));
% figure(1000),imshow(ftImg1);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Gaussian Fitting 1
xcut = 3901:1:4600;
ycut = 3901:1:4600;
[Xcut,Ycut] = meshgrid(xcut,ycut);
Img_cut = field(3901:1:4600,3901:1:4600);

Gauss2Mod1 = @(P,X0,Y0,k,x,y)...      % P is related to the size of the peak, greater->narrower
    1*exp( -( 1./P.*((x-X0).^2) + 1./P.*((y-Y0).^2) ))+k;

Gauss2Mod2 = @(P,X0,Y0,k,x,y)...      % P is related to the size of the peak, greater->narrower
    1*exp( -( 1./P.*((x-X0).^2) + 1./P.*((y-Y0).^2) ))+k;

StartP1 = [100,4250,4250,min(min(Img_cut))];
DataFit=[reshape(Xcut,[],1),reshape(Ycut,[],1),reshape(Img_cut,[],1)];
[GasFit1,GOF1] = fit([DataFit(:,1),DataFit(:,2)],DataFit(:,3),Gauss2Mod1,'StartPoint',StartP1);
Fitted1 = reshape(GasFit1(DataFit(:,1),DataFit(:,2)),[700,700]);
Eff1 = coeffvalues(GasFit1);
Pksize1 = Eff1(1);
disp('Gaussian Fitting for Image plane done! -->')
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SLM pattern setting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
STR = load('ExpPara20170718.mat');
OrigData = STR.OrigData;
parameters = OrigData(:,6:9);
% STR = load('slm20254050.mat');
% slm = STR.masking_0;

% :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
Rav1 = parameters(:,1);
dR1 = parameters(:,2);
Rav2 = parameters(:,3);
dR2 = parameters(:,4);

R1 = Rav1-dR1/2;
R2 = Rav1+dR1/2;
R3 = Rav2-dR2/2;
R4 = Rav2+dR2/2;

pxx=1920;
pxy=1080;
magnitude = 1;
x = linspace(-pxx*8/2,pxx*8/2,pxx);
y = linspace(-pxy*8/2,pxy*8/2,pxy);
[X,Y] = meshgrid(x,y);
rho = sqrt((X*magnitude).^2+(Y*magnitude).^2);

% :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
AnalysedRes = zeros(size(parameters,1),4);
% pname = 'D:\HUA';
pname = 'C:\Users\Xuanwen\Google Drive\thesisproj\DRIM\masks';
disp('Applying Double-Ring masks......')
for i = 28 %[6,21,22,28,56,64,65,96]
        r1 = R1(i);
        r2 = R2(i);
        r3 = R3(i);
        r4 = R4(i);
    slm = imread([pname,'\ta_p40_20170718\ta40_',num2str(i),'.bmp']);
    tA = zeros(size(Img,1),size(Img,2));
    tA(ceil(1+(size(tA,1)-size(slm,1))/2):ceil((size(tA,1)+size(slm,1))/2),...
        ceil(1+(size(tA,2)-size(slm,2))/2):ceil((size(tA,2)+size(slm,2))/2)) = slm;
    
    slm = imread([pname,'\ta_p40_20170718_inn\tainn40_',num2str(i),'.bmp']);
    tAinn = zeros(size(Img,1),size(Img,2));
    tAinn(ceil(1+(size(tA,1)-size(slm,1))/2):ceil((size(tA,1)+size(slm,1))/2),...
        ceil(1+(size(tA,2)-size(slm,2))/2):ceil((size(tA,2)+size(slm,2))/2)) = slm;
    
    slm = imread([pname,'\ta_p40_20170718_out\taout40_',num2str(i),'.bmp']);
    tAout = zeros(size(Img,1),size(Img,2));
    tAout(ceil(1+(size(tA,1)-size(slm,1))/2):ceil((size(tA,1)+size(slm,1))/2),...
        ceil(1+(size(tA,2)-size(slm,2))/2):ceil((size(tA,2)+size(slm,2))/2)) = slm;
    %     figure(8),imshow(tA0);
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Fourier Transform TWO
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ft2 = fftshift(fft2(fftshift(ft1.*tA)));
    ftImg2 = abs(ft2).^2;
    ftImg2 = ftImg2/max(max(ftImg2));
    ftImg2_cut = ftImg2(3901:1:4600,3901:1:4600);
    eval(['ftImg2_',num2str(i),'=ftImg2_cut;']);
    StartP2 = [100,4250,4250,min(min(ftImg2_cut))];
    DataFit=[reshape(Xcut,[],1),reshape(Ycut,[],1),reshape(ftImg2_cut,[],1)];
    [GasFit2,GOF2] = fit([DataFit(:,1),DataFit(:,2)],DataFit(:,3),Gauss2Mod2,'StartPoint',StartP2);
    eval(['Fitted2_',num2str(i),' = reshape(GasFit2(DataFit(:,1),DataFit(:,2)),[700,700]);'])
    Eff2 = coeffvalues(GasFit2);
    Pksize2 = Eff2(1);
    
    ft2 = fftshift(fft2(fftshift(ft1.*tAinn)));
    ftImg2 = abs(ft2).^2;
    ftImg2 = ftImg2/max(max(ftImg2));
    ftImg2_cut = ftImg2(3901:1:4600,3901:1:4600);
    eval(['ftImg2inn_',num2str(i),'=ftImg2_cut;']);
    StartP2 = [100,4250,4250,min(min(ftImg2_cut))];
    DataFit=[reshape(Xcut,[],1),reshape(Ycut,[],1),reshape(ftImg2_cut,[],1)];
    [GasFit2,GOF2] = fit([DataFit(:,1),DataFit(:,2)],DataFit(:,3),Gauss2Mod2,'StartPoint',StartP2);
    eval(['Fitted2inn_',num2str(i),' = reshape(GasFit2(DataFit(:,1),DataFit(:,2)),[700,700]);'])
    Eff2inn = coeffvalues(GasFit2);
    Pksize2inn = Eff2inn(1);
    
    ft2 = fftshift(fft2(fftshift(ft1.*tAout)));
    ftImg2 = abs(ft2).^2;
    ftImg2 = ftImg2/max(max(ftImg2));
    ftImg2_cut = ftImg2(3901:1:4600,3901:1:4600);
    eval(['ftImg2out_',num2str(i),'=ftImg2_cut;']);
    StartP2 = [100,4250,4250,min(min(ftImg2_cut))];
    DataFit=[reshape(Xcut,[],1),reshape(Ycut,[],1),reshape(ftImg2_cut,[],1)];
    [GasFit2,GOF2] = fit([DataFit(:,1),DataFit(:,2)],DataFit(:,3),Gauss2Mod2,'StartPoint',StartP2);
    eval(['Fitted2out_',num2str(i),' = reshape(GasFit2(DataFit(:,1),DataFit(:,2)),[700,700]);'])
    Eff2out = coeffvalues(GasFit2);
    Pksize2out = Eff2out(1);
    
    %     Pk2_0 = (Rav1(i)*dR1(i)+Rav2(i)*dR2(i))/(Rav1(i)^3*dR1(i)+Rav2(i)^3*dR2(i));
    AnalysedRes(i,:) = [Pksize1,Pksize2,Pksize2inn,Pksize2out];
    disp([num2str(i),' | 470 : ',num2str(AnalysedRes(i,:))])
end
% delete(gcp)
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure(5000),
% subplot(2,2,1),imshow(OTF);title('Bead');
% subplot(2,2,2),imshow(Img);title('Img of Bead');
% subplot(2,2,3),imshow(ftImg1);title('After the 1st FT');
% subplot(2,2,4),imshow(ftImg2);title('After the 2nd FT');
% imshow([OTF,Img;ftImg1,ftImg2])
% mesh(ftImg2(2000:2250,2000:2250));

% scatter3(reshape(Xcut,[],1),reshape(Ycut,[],1),reshape(Img_cut,[],1));
% hold on
% mesh(xcut,ycut,Fitted1)

figure(2000)
subplot(3,1,1),imshow(ftImg2out_28);title('PSF of Outter Single Ring Modulation');
subplot(3,1,2),imshow(ftImg2inn_28);title('PSF of Inner Single Ring Modulation');
subplot(3,1,3),imshow(ftImg2_28);title('PSF of Double Ring Modulation');

figure(3000)
subplot(3,1,1),plot(xcut-2,ftImg2out_28(352,:),xcut,Img_cut(350,:));title('PSF of Outter Single Ring Modulation');
subplot(3,1,2),plot(xcut-2,ftImg2inn_28(352,:),xcut,Img_cut(350,:));title('PSF of Inner Single Ring Modulation');
subplot(3,1,3),plot(xcut-2,ftImg2_28(352,:),xcut,Img_cut(350,:));title('PSF of Double Ring Modulation');
