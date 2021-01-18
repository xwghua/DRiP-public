% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate a bead pattern with spcific size and sampling freq
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

scale = 5; % um
sf = 20E-3; %um
x = linspace(-85,85,1700*scale); % um
y = linspace(85,-85,1700*scale); % um
[X,Y] = meshgrid(x,y);
mu = [0,0];
bdiam = 0.5; % um
% sigma = [(bsize/2)^2,0;0,(bsize/2)^2];
% dist = mvnpdf([X(:),Y(:)],mu,sigma);
% bead = reshape(dist,size(X));
otf_bead = (X.^2+Y.^2)<=(bdiam/2)^2;
figure,imshow(otf_bead);