function [ masking ] = MaskFunc( parameters,period,lambda,z0,dx,dy )
%MASKFUNC Summary of this function goes here
%   Detailed explanation goes here

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The parameters must be in the form of 
%     " [ Rav1  dR1  Rav2  dR2 ] "
% in the first four columns.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
disp('     The parameters must be in the form of ')
disp('         " [ Rav1  dR1  Rav2  dR2 ] "')
disp('     in the first four columns.')
disp('     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')

Rav1 = parameters(:,1);
dR1 = parameters(:,2);
Rav2 = parameters(:,3);
dR2 = parameters(:,4);

R1 = Rav1-dR1/2;
R2 = Rav1+dR1/2;
R3 = Rav2-dR2/2;
R4 = Rav2+dR2/2;

disp(' ')
disp('     Data read!')
% =================GRATING=======================
pxx=1920;
pxy=1080;
magnitude = 1;
x = linspace(-pxx*8/2,pxx*8/2,pxx);
y = linspace(-pxy*8/2,pxy*8/2,pxy);
[X,Y] = meshgrid(x,y);
rho = sqrt((X*magnitude-85*8).^2+(Y*magnitude+50*8).^2);
grating = 1-repmat(mod((-959:1:960)/pxx*period,1),pxy,1);
% =================GRATING END=======================
% ===================CHIRP===========================
% lambda = 680e-9;
focus = 20e-2;
fsf = 8e-6;
% z0 = 0e-3;
[chirpX, chirpY] = meshgrid(((-959:1:960)+dx)/(lambda*focus/fsf),((-539:1:540)+dy)/(lambda*focus/fsf));
chirp_angle = sqrt(max(0,lambda^-2-chirpX.^2-chirpY.^2));
chirp_mask = -2*pi*chirp_angle*z0;
angle_total = (chirp_mask*256/2/pi-256*floor(chirp_mask/2/pi))/256;
% =================CHIRP END=========================
disp('     Parameters set!')

% PATH = 'C:\Users\xuhua\Google Drive\thesisproj\DRIM\masks\';
% NOP = length(parameters);

% mkdir([PATH,mapathin])
% mkdir([PATH,tapathin])
% mkdir([PATH,mapathin,'_inn'])
% mkdir([PATH,tapathin,'_inn'])
% mkdir([PATH,mapathin,'_out'])
% mkdir([PATH,tapathin,'_out'])
% disp(['     Path: ',PATH,mapathin,'||',tapathin])
% disp('     -------------------- Created! --------------------')

% for i = 1:1:NOP
    r1 = R1;
    r2 = R2;
    r3 = R3;
    r4 = R4;
    tA = (rho>=r1).*(rho<=r2)+(rho>=r3).*(rho<=r4);
    masking = tA.*(mod(grating+angle_total,1));
%     masking = fliplr(masking);
%     imwrite(masking,[PATH,mapathin,'\mask',num2str(period),'_',num2str(i),'.bmp'])
%     imwrite(tA,[PATH,tapathin,'\ta',num2str(period),'_',num2str(i),'.bmp'])
%     disp(['     ...\',mapathin,'||',tapathin,'--> ..-',num2str(i),'.bmp created!'])
% end
% delete(gcp)

% figure(1),imshow(masking)
end

