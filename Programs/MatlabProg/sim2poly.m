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
%% set range & ring mask
range = linspace(-1E-0,1E-0,10000);
x = range;
y = range;
[X,Y]=meshgrid(x,y);
rho = zeros(length(y),length(x));
tA = zeros(length(y),length(x));
tB = ones(length(y),length(x));
res2 = zeros(length(y),length(x));
res4 = zeros(length(y),length(x));
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
%% set random points
polypx = [rand(40,1),rand(40,1)];
polypy = [rand(40,1),rand(40,1)];
W0 = 3E-3;
gaussian_0 = exp(-(rho.^2)/(W0^2));
res = (fftshift(abs(fft2(gaussian_0)))).^2;
res = res./max(max(res));
res3 = (fftshift(abs(fft2(tA.*gaussian_0)))).^2;
res3 = res3./max(max(res3));
%% Fourier Transformation
% gaussian_0d = zeros(length(y),length(x),40);
parpool
fprintf('\n parpool starts......');
tic
parfor cont=1:40
    gaussian_0d = exp(-(rho.^2)/(W0^2)).*exp(-1i*k*Y*polypx(cont)-1i*k*X*polypy(cont));
    res2 = res2+(fftshift(abs(fft2(gaussian_0d)))).^2;
    res4 = res4+(fftshift(abs(fft2(tA.*gaussian_0d)))).^2;
    fprintf('\n one turn ends......time passed: %f secs',toc);
    tic
end
delete(gcp)
fprintf('\n parpool ends......Total time: %f secs',toc);
res2 = res2./max(max(res2));
res_tot = res+res2;
res4 = res4./max(max(res4));
res_tot2 = res3+res4;

noise = var(res_tot2(:));
PSF = res3;
im_obj = deconvwnr(res_tot2,PSF,0);
figure(2),subplot(2,2,1),imshow(res_tot);
subplot(2,2,2),imshow(res_tot2);
subplot(2,2,3),imshow(PSF/max(max(PSF)));
subplot(2,2,4),imshow(im_obj/max(max(im_obj)));
%%
toc