clc
x = linspace(-100e-6,100e-6,200);
y = linspace(-100e-6,100e-6,200);
z = linspace(-30e-3,30e-3,800);

[X,Y,Z] = meshgrid(x,y,z);

x0 = x(1:40:200);
y0 =y(1:40:200);
z0 = z(1:160:800);
slice(X,Y,Z,Ii,x0,y0,z0);
alpha .2
shading interp   %网格线设置成透明
%  face_alpha=0.05
% caxis([0 0.6])
colormap jet
set(gca,'xdir','reverse')
xlabel('x');
ylabel('y');
zlabel('z');
colorbar