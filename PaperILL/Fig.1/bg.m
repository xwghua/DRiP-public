clear,clc

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set coordinates
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
scale = 4e-6;
x = linspace(-100e-6,100e-6,200);
y = linspace(-100e-6,100e-6,200);
z = linspace(-30e-3,30e-3,800);

[X,Y] = meshgrid(x,y);
r = sqrt(X.^2 + Y.^2);
R1 = 1500e-6;
R2 = 3000e-6;
f = 0.2;

lambda = 680e-9;
k = 2*pi/lambda;
sintheta1 = R1/sqrt(R1^2 + f^2);
sintheta2 = R2/sqrt(R2^2 + f^2);
plen = 2*lambda/abs(sqrt(1-sintheta1^2)-sqrt(1-sintheta2^2))
period = (z(end)-z(1))/plen

U = zeros(size(r,1),size(r,2),size(z,2));

beta1 = k*sintheta1;
beta2 = k*sintheta2;

w0 = 24.2e-6 * 40;
ZR = pi*w0^2/lambda;
% RZ = z/(1+ZR^2);
RZ = z + ZR^2./z;
w = w0 * sqrt(1+(z/ZR).^2);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
parfor zi=1:size(z,2)
    U(:,:,zi) = w0/w(zi)*exp(-1i*sintheta1*beta1*z(zi)/2+1i*k*z(zi)-1i*atan(z(zi)/ZR)).*...
        besselj(0,r.*beta1/(1+1i*z(zi)/ZR)).*...
        exp((1i*k/2/RZ(zi)-1/(w(zi)^2)).*(r.^2+z(zi)^2*sintheta1^2)) +...
        ...
        w0/w(zi)*exp(-1i*sintheta2*beta2*z(zi)/2+1i*k*z(zi)-1i*atan(z(zi)/ZR)).*...
        besselj(0,r.*beta2/(1+1i*z(zi)/ZR)).*...
        exp((1i*k/2/RZ(zi)-1/(w(zi)^2)).*(r.^2+z(zi)^2*sintheta2^2));
end
% fprintf('\n');
Ii = abs(U).^2;
Ii = Ii/max(Ii(:));
parfor zi=1:size(z,2)
    ii = squeeze(Ii(:,:,zi));
     if zi<201
        ii(ceil(1:end/2),ceil(1:end/2))=0; % cut 3/4 of the volumetric psf
    end
    imwrite(uint8(255*ii),['slices34\',num2str(zi),'.tif'])
    disp(zi)
end
% Ii = (Ii-min(Ii(:))) / (max(Ii(:))-min(Ii(:)));
% %
% figure(100),
% for j = 1:size(z,2)
%     im = Ii(:,:,j);
%     im = (im-min(im(:)))/(max(im(:))-min(im(:)));
%     imagesc(im);
% %     imshow(im,hot);
%     title(['j = ',num2str(j)]);
%     colorbar
%     pause(0.001)
% end
% %
im2 = Ii(100,:,:);
% cl = abs(exp(-1i*z*ZR^2/2/k*beta1^2)+exp(-1i*z*ZR^2/2/k*beta2^2)).^2;
im2 = (im2-min(im2(:)))/(max(im2(:))-min(im2(:)));
figure(201),imshow(squeeze(im2))
% figure(200),plot(cl)
%%
clc,
improj = Ii(:,:,401);
improj = squeeze(improj);
improj = (improj-min(improj(:)))/(max(improj(:))-min(improj(:)));
% improj = [zeros(300,800);improj;zeros(300,800)];
% fig = figure(500);
% img = imshow(uint8(255*improj),... %'Colormap', jet(255),...
%     'Border','tight','InitialMagnification','fit');
% set (gcf,'Position',[512,256,512,512])
% C = colorbar;
% C.Location = 'west';
% C.Position = [0.05,0.05,0.05,0.3];
% C.FontSize = 10;
% C.Color = 'white';
% C.AxisLocation = 'in';
% save the figure with figure handle
% saveas(fig,'xy34.tif','tiffn');
imwrite(uint8(255*improj),'xy34.tif')