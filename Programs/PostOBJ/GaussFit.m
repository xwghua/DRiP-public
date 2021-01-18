xcut = (3901:1:4600)*20-3900*20;
ycut = (3901:1:4600)*20-3900*20;
[Xcut,Ycut] = meshgrid(xcut,ycut);
Img_cut = Img_0(3901:1:4600,3901:1:4600);
ftImg2_cut = ftImg2(3901:1:4600,3901:1:4600);

Img_1d = Img_cut(ceil(end/2),:);
ftImg2_1d = ftImg2_cut(ceil(end/2),:);

Gauss2Mod1 = @(P,X0,k,x)...      % P is related to the size of the peak, greater->narrower
    max(max(Img_1d)).*exp( -1./P.*((x-X0).^2))+k;

Gauss2Mod2 = @(P,X0,k,x)...      % P is related to the size of the peak, greater->narrower
    max(max(ftImg2_1d)).*exp( -1./P.*((x-X0).^2))+k;

StartP1 = [500,350*20,min(Img_1d)];
StartP2 = [300,350*20,min(ftImg2_1d)];

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

figure(1),
subplot(1,2,1),
scatter(xcut,Img_1d);
hold on
plot(xcut,Fitted1);
title(['Gaussian | FWHM = ',num2str(2*sqrt(log(2)*Eff1(1)))])
hold off

subplot(1,2,2),
scatter(xcut,ftImg2_1d);
hold on
plot(xcut,Fitted2);
title(['Double-ring | FWHM = ',num2str(2*sqrt(log(2)*Eff2(1)))])
hold off

figure(2),
imshow([Img_cut,ftImg2_cut])