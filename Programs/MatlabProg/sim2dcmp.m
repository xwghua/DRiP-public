%% Two-dimensional sub-diffraction light beam simulation -- TEST
%% Initialize all & Time counting begins
clear;
disp('Program begins...');
tic
% hintbar=waitbar(0,'please wait...');                                        % hintbar initialization
%% Parameters setting
lambda = 632.8E-9;                % wave length = 632 nm
k = 2*pi/lambda;
focus = 200*10^-3;            % the focus of lens after the ring mask
gausswid = 5E6;
range = linspace(-1E-6,1E-6,200);
x = range;
y = range;
rho = zeros(length(y),length(x));
for ii = 1:1:length(x)
   for jj = 1:1:length(y)
      rho(jj,ii) = sqrt(x(ii)^2 + y(jj)^2);
   end
end
% For each ring, there are two variables that determine the area of the
% ring, that is the Rav, which equals (R1+R2)/2, and the ¦¤R, which equals 
% = |R1-R2|. These two variables will be useful in the approximate formula
% of the wave function and the function of intensity. According to the
% article, Rav can have the values of 600 um, 500 um and 50 um, and ¦¤R
% could be around 200 um.
Rav1 = 2100E-6;
dR1 = 10E-6;
R1 = Rav1-dR1/2;
R2 = Rav1+dR1/2;

Rav2 = 4300E-6;
dR2 = 200E-6;
R3 = Rav2-dR2/2;
R4 = Rav2+dR2/2;
Ii=(exp(-((rho*gausswid).^2))).^2;

% ***********************************
para1 = 1/lambda/focus;
para2 = rho*para1;
bessel2 = R2./para2.*besselj(1,2*pi*R2*para2);
bessel1 = R1./para2.*besselj(1,2*pi*R1*para2);
bessel4 = R4./para2.*besselj(1,2*pi*R4*para2);
bessel3 = R3./para2.*besselj(1,2*pi*R3*para2);
besselall1 = bessel2-bessel1;
besselall2 = bessel2-bessel1+bessel4-bessel3;
besselall3 = bessel4-bessel3;
% ***********************************
intensity1 = (para1.*Ii.*besselall1).^2;
intensity2 = (para1.*Ii.*besselall2).^2; intensity2p5 = (para1*besselall2).^2;
intensity3 = (para1.*Ii.*besselall3).^2;
intensity1 = intensity1/max(max(intensity1));
intensity2 = intensity2/max(max(intensity2)); intensity2p5 = intensity2p5/max(max(intensity2p5));
intensity3 = intensity3/max(max(intensity3));
ratio = [];
%% draw graphs
% [x,y] = pol2cart(theta,rho);
% figure(1),
% mesh(x,y,intensity1)
% figure(2),
% mesh2=mesh(x,y,intensity2);
figure(3),
n=100;
plot(y(:),Ii(n,:),y(:),intensity2(n,:),y(:),intensity2p5(n,:))
%% analysis
% ratio_new = [peakratio(intensity1),peakratio(intensity2),peakwidth(intensity2)];
% ratio = [ratio;ratio_new];
toc