%% Two-dimensional sub-diffraction light beam simulation -- ANALYSIS
%% Initialize all & Time counting begins
clear;
disp('Program begins...');
tic
hintbar=waitbar(0,'please wait...');                                        % hintbar initialization
%% Parameters setting
lambda = 633E-9;                % wave length = 670 nm // equipped with red fluorescence
k = 2*pi/lambda;
focus = 200*10^-3;            % the focus of lens after the ring mask
range = linspace(-1E-2,1E-2,200);
x = range;
y = range;
rho = zeros(length(y),length(x));
for ii = 1:1:length(x)
   for jj = 1:1:length(y)
      rho(jj,ii) = sqrt(x(ii)^2 + y(jj)^2);
   end
end
ratio = [100,100];
ratio_new = [];
peak_width = 1E-3;
% *************************************************************************
% For each ring, there are two variables that determine the area of the
% ring, that is the Rav, which equals (R1+R2)/2, and the ?R, which equals
% = |R1-R2|. These two variables will be useful in the approximate formula
% of the wave function and the function of intensity. According to the
% article, Rav can have the values of 600 um, 500 um and 50 um, and ?R
% could be around 200 um.
% *************************************************************************
% in this program we are going to cover the range available for Rav and dR
% to find the most appropriate values for experiment.
% Rav1 = 50 - 2000
% Rav2 = 2000 - 4300
% dR1 = 20-1500
%dR2 = 10-1000
% *************************************************************************
for Rav1 = 50:100:2000  % 20points
    for Rav2 = 2000:100:4000 % 21 points
        for dR1 = 20:50:2000    % 40 points
            for dR2 = 10:50:1000 % 20 points
                waitbar((Rav1-50)/100/20+(Rav2-2000)/100/20/21+(dR1-20)/50/20/21/40+(dR2-10)/50/20/21/40/20,hintbar,...
                    ['Processing...' num2str(((Rav1-50)/100/20+(Rav2-2000)/100/20/21+(dR1-20)/50/20/21/40+(dR2-10)/50/20/21/40/20)*100) '%'])  
                % processing bar [no practical functions here...omit this...]
                R1 = (Rav1*1E-6)-(dR1*1E-6)/2;
                R2 = (Rav1*1E-6)+(dR1*1E-6)/2;
                R3 = (Rav2*1E-6)-(dR2*1E-6)/2;
                R4 = (Rav2*1E-6)+(dR2*1E-6)/2;
                Ii=1;
                % ***********************************
                para1 = 1/lambda/focus;
                para2 = rho*para1;
                bessel2 = R2./para2.*besselj(1,2*pi*R2*para2);
                bessel1 = R1./para2.*besselj(1,2*pi*R1*para2);
                bessel4 = R4./para2.*besselj(1,2*pi*R4*para2);
                bessel3 = R3./para2.*besselj(1,2*pi*R3*para2);
                besselall1 = bessel2-bessel1;
                besselall2 = bessel2-bessel1+bessel4-bessel3;
                % ***********************************
                intensity1 = (para1*besselall1).^2;
                intensity2 = (para1*besselall2).^2;
                % *****analysis*****
                ratio_new = [ratio_new;[Rav1,Rav2,dR1,dR2,peakratio(intensity1),peakratio(intensity2),peakwidth(intensity2)]];
                if ratio_new(end,6)<ratio(2)
                    ratio = ratio_new(end,5:6);
                    zRav1_final = Rav1;
                    zdR1_final = dR1;
                    zRav2_final = Rav2;
                    zdR2_final = dR2;
                end
                if ratio_new(end,7) <= peak_width
                    peak_width = ratio_new(end,7);
                    NARW_zRav1 = Rav1;
                    NARW_zdR1 = dR1;
                    NARW_zRav2 = Rav2;
                    NARW_zdR2 = dR2;
                end
            end
        end
    end
end
close(hintbar)
%% end of the program
toc