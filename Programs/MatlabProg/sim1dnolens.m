%% One-dimensional sub-diffraction light beam simulationm -- TEST
%% Initialize all & time counting begins
clear ,clc;
tic
%% Set the parameters
lambda=543.5E-9;
k=2*pi/lambda;
b_inner=3E-3;
b_outer=1.5E-3;
focus=152E-3;
angle_inner=1.25/180*pi;
angle_outer=2.5/180*pi;
inner_upper=focus*tan(angle_inner)+0.5*b_inner;
inner_lower=focus*tan(angle_inner)-0.5*b_inner;
outer_upper=focus*tan(angle_outer)+0.5*b_outer;
outer_lower=focus*tan(angle_outer)-0.5*b_outer;
% y_num=-100:0.01:100;
% y=y_num*10^-6;
% sin_theta=y./((y.^2+focus^2).^0.5);
%% Run functions
% u1=pi*b_outer*sin_theta/lambda;
% test1=sin(u1)./u1.*cos(pi*b_inner*3/lambda*sin_theta);
% u2=pi*b_inner*sin_theta/lambda;
% test2=sin(u2)./u2.*cos(pi*b_inner*2/lambda*sin_theta);
% test3=(sin(u1)./u1.*cos(pi*b_inner*3/lambda*sin_theta)+sqrt(0.5)*sin(u2)./u2.*cos(pi*b_inner*2/lambda*sin_theta)).^2;
for y_num=-100:0.01:100
    num=round((y_num+100)/0.01+1);
    y(1,num)=y_num*10^-6;
    sin_theta=y(1,num)/((y(1,num)^2+focus^2)^0.5);
    fun=@(yy)exp(-1i*k*yy*sin_theta);
    u1(1,num)=integral(fun,inner_lower,inner_upper);
    u2(1,num)=integral(fun,-inner_upper,-inner_lower);
    u_mix1(1,num)=u1(1,num)+u2(1,num);
    intensity1(1,num)=u_mix1(1,num)^2;
    % **********************************
    u3(1,num)=integral(fun,outer_lower,outer_upper);
    u4(1,num)=integral(fun,-outer_upper,-outer_lower);
    u_mix2(1,num)=u3(1,num)+u4(1,num);
    intensity2(1,num)=u_mix2(1,num)^2;
    % **********************************
    u_mix(1,num)=u_mix1(1,num)+u_mix2(1,num);
    intensity(1,num)=u_mix(1,num)^2;
end
%% Pre-drawing Processing
intensity1=intensity1/max(intensity1);
intensity2=intensity2/max(intensity2);
intensity=intensity/max(intensity);
%% Draw figures
figure(1);
plot(y,intensity1,y,intensity2);
figure(2);
plot(y,intensity);
%% time counting ends
toc