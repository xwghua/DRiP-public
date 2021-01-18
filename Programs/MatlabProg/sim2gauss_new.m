% when applying gauss bean to incident illumination, you need to utilize
% FFT to accelerate the pace of processing.
clear,clc
disp('Program begins...');
tic
%% set parameters
 
% k = 2*pi/lambda;
% focus = 200*10^-3;            % the focus of lens after the ring mask
% *********************************
Rav1 = 100;         dR1 = 25;
Rav2 = 200;         dR2 = 50;
% *********************************
R1 = Rav1-dR1/2;
R2 = Rav1+dR1/2;
R3 = Rav2-dR2/2;
R4 = Rav2+dR2/2;
%% set bead
x = linspace(-85,85,1700);
y = linspace(-85,85,1700);
[X,Y] = meshgrid(x,y);
mu = [0,0];
bsize = 1;
sigma = [(bsize/2)^2,0;0,(bsize/2)^2];
dist = mvnpdf([X(:),Y(:)],mu,sigma);
bead = reshape(dist,size(X));
%% set ring mask
magnitude = 80;
rho = sqrt((X*magnitude).^2+(Y*magnitude).^2);
tA = (rho>=R1).*(rho<=R2)+(rho>=R3).*(rho<=R4);
r_stop = 2*1.45/sqrt(1.515^2-1.45^2)*1000;
stop = (sqrt((X*magnitude).^2+(Y*magnitude).^2))<=r_stop;
%% propagation
ipt = fftshift(fft2(fftshift(bead)));
int_ipt = (abs(ipt)).^2;
int_ipt = int_ipt/max(max(int_ipt));
% *************************************
ctr = fftshift(fft2(fftshift(ipt.*stop)));
int_ctr = (abs(ctr)).^2;
int_ctr = int_ctr/max(max(int_ctr));
% *************************************
opt = fftshift(fft2(fftshift(ipt.*tA.*stop)));
int_opt = (abs(opt)).^2;
int_opt = int_opt/max(max(int_opt));
% *************************************
toc
%% plotting
figure(1)
subplot(2,3,1),imshow(bead),title('bead');
subplot(2,3,2),imshow(int_ipt),title('input');
subplot(2,3,3),imshow(stop),title('stop');
subplot(2,3,4),imshow(tA),title('tA');
subplot(2,3,5),imshow(int_ctr),title('control');
subplot(2,3,6),imshow(int_opt),title('output');
colormap(hot);