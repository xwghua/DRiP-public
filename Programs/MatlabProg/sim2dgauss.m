% when applying gauss bean to incident illumination, you need to utilize
% FFT to accelerate the pace of processing.
clear;
disp('Program begins...');
tic
%% set parameters
lambda = 632.8E-9;                % wave length = 670 nm // equipped with red fluorescence
k = 2*pi/lambda;
focus = 200*10^-3;            % the focus of lens after the ring mask
% *********************************
Rav1 = 2100E-6;
dR1 = 50E-6;
R1 = Rav1-dR1/2;
R2 = Rav1+dR1/2;
% *********************************
Rav2 = 4300E-6;
dR2 = 200E-6;
R3 = Rav2-dR2/2;
R4 = Rav2+dR2/2;
%% set range & ring m                                                   ask
range = linspace(-1E-0,1E-0,5000);
x = range;
y = range;
[X,Y]=meshgrid(x,y);
rho = zeros(length(y),length(x));
tA = zeros(length(y),length(x));
tB = ones(length(y),length(x));
for ii = 1:1:length(x)
    for jj = 1:1:length(y)
        rho(jj,ii) = sqrt(x(ii)^2 + y(jj)^2);
        if (rho(jj,ii)>R1 && rho(jj,ii)<R2)||(rho(jj,ii)>R3 && rho(jj,ii)<R4)
            tA(jj,ii)=1;
        else
            if rho(jj,ii)==R1 || rho(jj,ii)==R2 || rho(jj,ii)==R3 || rho(jj,ii)==R4
                tA(jj,ii)=0.5;
            end
        end
    end
end
%% Fourier Transformation
W0 = 3E-3;
gaussian_0 = exp(-(rho.^2)/(W0^2));
gaussian_0d = (exp(-(rho.^2)/(W0^2)).*exp(-1i*k*Y*0.65));
res = (fftshift(abs(fft2(gaussian_0)))).^2;
res = res./max(max(res));
res2 = (fftshift(abs(fft2(gaussian_0d)))).^2;
res2 = res2./max(max(res2));
res_tot = res+res2;
% figure(1),mesh(X,Y,tA);
% figure(2),mesh(X,Y,res2);
% figure(3),mesh(X,Y,res_tot);
% figure(1),imshow(tA);
% figure(2),imshow(res2);
% figure(3),imshow(res_tot);

res3 = (fftshift(abs(fft2(tA.*gaussian_0)))).^2;
res3 = res3./max(max(res3));
res4 = (fftshift(abs(fft2(tA.*gaussian_0d)))).^2;
res4 = res4./max(max(res4));
res_tot2 = res3+res4;
noise = var(res_tot2(:));
PSF = res;
% im_obj = deconvwnr(res_tot2,PSF,1E-4/noise);
im_obj = deconvwnr(res_tot2,PSF,0);
for devcont = 1:1:4
    im_obj = deconvwnr(im_obj,PSF,0);
end
% im_obj = ifft2(fftshift(fft2(res_tot2)).*tA./(tA.^2+ones(length(y),length(x))*1E-55));
% im_obj = im_obj/max(max(im_obj));
% figure(4),mesh(res4);
% figure(5),mesh(X,Y,res_tot2);
% figure(4),imshow(res4);
% figure(5),imshow(res_tot2);
figure(2),subplot(2,2,1),imshow(res_tot);
subplot(2,2,2),imshow(res_tot2);
subplot(2,2,3),imshow(PSF/max(max(PSF)));
subplot(2,2,4),imshow(im_obj/max(max(im_obj)));
%%
toc