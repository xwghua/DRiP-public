%% One-dimensional sub-diffraction light beam simulationm -- TEST
%% Initialize all & time counting begins
clear ,clc;
disp('Program begins...');
tic
hintbar=waitbar(0,'please wait...');                                        % hintbar initialization
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
%% Run functions
for z_num=(focus-0.15E-3):0.30E-5:(focus+0.15E-3)
    num4z=round((z_num-(focus-0.15E-3))/(0.30E-5)+1);
    for y_num=-50:0.1:50
        num=round((y_num+50)/0.1+1);
        waitbar((num4z-1)/100+(num-1)/1000/100,hintbar,['Processing...' ...
            num2str((num4z-1)+(num-1)/1000) '%'])                           % processing bar [no practical functions here...omit this...]
        % above shows the progress...
        y(num4z,num)=y_num*10^-6;
        z(num4z,num)=z_num;
%         sin_theta=y(num4z,num)/((y(num4z,num)^2+focus^2)^0.5);
        sin_theta=y(num4z,num)/focus;                                       % approximation
        % reannounce the constants *****begin*****
        para1=sqrt(1.0/lambda/z(num4z,num));                                % ¡Ì(1/z/¦Ë)
        para2=exp(-1i*pi/4);                                                % e^(-i¦Ğ/4)
        para3=exp(1i*k*z(num4z,num));                                       % e^ikz
        para4=exp(1i*k*(y(num4z,num)^2)/2/z(num4z,num));                    % e^(iky^2/2z)
        para=para1*para2*para3*para4;
        % reannounce the constants *****cmplt*****
        fun=@(yy)para*exp(-1i*k*yy*sin_theta).*exp(-1i*k/2.*yy.*yy.*...
            (1.0/focus-1.0/z(num4z,num))).*exp(-1i*k*y(num4z,num)*yy/z(num4z,num));
        u1(num4z,num)=integral(fun,inner_lower,inner_upper);
        u2(num4z,num)=integral(fun,-inner_upper,-inner_lower);
        u_mix1(num4z,num)=u1(num4z,num)+u2(num4z,num);
        intensity1(num4z,num)=(abs(u_mix1(num4z,num)))^2;
        % **********************************
        u3(num4z,num)=integral(fun,outer_lower,outer_upper);
        u4(num4z,num)=integral(fun,-outer_upper,-outer_lower);
        u_mix2(num4z,num)=u3(num4z,num)+u4(num4z,num);
        intensity2(num4z,num)=(abs(u_mix2(num4z,num)))^2;
        % **********************************
        u_mix(num4z,num)=u_mix1(num4z,num)+u_mix2(num4z,num);
        intensity(num4z,num)=(abs(u_mix(num4z,num)))^2;
    end
    %% Pre-drawing Processing (data transformation and organization)
    intensity1(num4z,:)=intensity1(num4z,:)/max(intensity1(num4z,:));
    intensity2(num4z,:)=intensity2(num4z,:)/max(intensity2(num4z,:));
    intensity(num4z,:)=intensity(num4z,:)/max(intensity(num4z,:));
end
close(hintbar)
    %% Draw figures
%     figure(2*num4z-1);
%     plot(y(num4z,:),intensity1(num4z,:),y(num4z,:),intensity2(num4z,:));
%     figure(2*num4z);
%     plot(y(num4z,:),intensity(num4z,:));
figure(2)
mesh(y(1,:),z(:,1),intensity);

%% time counting ends
toc