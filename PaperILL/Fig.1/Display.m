clc
clearvars -except U Ii

% scale = 1;
x = linspace(0,100e-6,100);
y = linspace(-100e-6,100e-6,200);
z = linspace(-30e-3,30e-3,800);

[X,Y,Z] = meshgrid(x,y,z);
% r3 = sqrt(X.^2+Y.^2);

figure(1000),
hold on
for isov = [0.04,0.06,0.08,0.12,0.24,0.3,0.43,0.58,0.73,0.86,0.99]
[faces,verts,colors] = isosurface(X,Y,Z,Ii(:,101:200,:),isov*max(Ii(:)),Ii(:,101:200,:));
p1 = patch('Vertices', verts, 'Faces', faces, ... 
     'FaceVertexCData', colors, ... 
     'FaceColor','interp', ... 
     'edgecolor', 'interp');
isonormals(X,Y,Z,Ii(:,101:200,:),p1);
daspect([100e-6,100e-6,30e-3])
view(3)
alpha .3
% axis vis3d;
colormap hot
axis tight
camlight 
lighting gouraud
drawnow
disp(isov)
end
hold off

%%
% figure(100),
% for j = 401
%     im = Ii(:,:,j);
%     im = (im-min(im(:)))/(max(im(:))-min(im(:)));
%     imagesc(im);
% %     imshow(im,hot);
%     title(['j = ',num2str(j)]);
%     colorbar
%     pause(0.001)
% end