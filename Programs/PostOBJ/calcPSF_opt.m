function [psf,gkx,gkw1] = calcPSF_opt(p1, p2, p3, fobj, NA, xspace, yspace, lambda, M, n, centerArea)

timerVal = tic;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
k = 2*pi*n/lambda;
alpha = asin(NA/n);
xlength = length(xspace);
ylength = length(yspace);
zeroline = zeros(1, length(yspace) );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
pattern = zeros(xlength, ylength);
centerPT = ceil(length(xspace)/2);

hwait = waitbar(0,'Processing...');
[ gkx, gkw1, gkw2 ] = kronrod ( 100, 1e-12 );
        gkx = [-gkx(1:end-1),fliplr(gkx)]*alpha/2+alpha/2;
        gkw1 = [gkw1(1:end-1),fliplr(gkw1)]*alpha/2;
        gklen = length(gkx);
%         disp([gkx',gkw1']);
u = 4*k*(p3*1)*(sin(alpha/2)^2);
Koi = M/((fobj*lambda)^2)*exp(-1i*u/(4*(sin(alpha/2)^2)));

for a=centerArea(1):centerPT
    patternLine = zeroline;
    x1 = xspace(a);
%     fprintf('%3.4f\n',x1 *1e6)
    parfor b=a:centerPT 
        x2 = yspace(b);          
        xL2normsq = (((x1+M*p1)^2+(x2+M*p2)^2)^0.5)/M;        
%         fprintf('%3.4f\n',((x1+M*p1)^2+(x2+M*p2)^2)^0.5 * 1e6)
        v = k*xL2normsq*sin(alpha);            
%         fprintf('%3.6f, %3.6f \n',u,v)
        
%         disp(Koi)
%         intgrand = @(theta) (sqrt(cos(theta))) .* (1+cos(theta))  .*  ...
%             (exp((1i*u/2)* (sin(theta/2).^2) / (sin(alpha/2)^2)))  .*  ...
%             (besselj(0, sin(theta)/sin(alpha)*v))  .*  (sin(theta));
%%        
%         intgrand_re = @(theta) (sqrt(cos(theta))) .* (1+cos(theta))  .*  ...
%             (cos((u/2)* (sin(theta/2).^2) / (sin(alpha/2)^2)))  .*  ...
%             (besselj(0, sin(theta)/sin(alpha)*v))  .*  (sin(theta));
%         
%         intgrand_im = @(theta) (sqrt(cos(theta))) .* (1+cos(theta))  .*  ...
%             (sin((u/2)* (sin(theta/2).^2) / (sin(alpha/2)^2)))  .*  ...
%             (besselj(0, sin(theta)/sin(alpha)*v))  .*  (sin(theta));
%         warning off;
%         I0 = integral(@(theta)intgrand (theta),0,alpha);  
%         I0_re = integral(@(theta)intgrand_re (theta),0,alpha);
%         I0_im = integral(@(theta)intgrand_im (theta),0,alpha);
        I0_re = 0; I0_im = 0;
        for i = 1:1:gklen
            theta = gkx(i);
            I0_re = I0_re + ((sqrt(cos(theta))) .* (1+cos(theta))  .*  ...
            (cos((u/2)* (sin(theta/2).^2) / (sin(alpha/2)^2)))  .*  ...
            (besselj(0, sin(theta)/sin(alpha)*v))  .*  (sin(theta)))*gkw1(i);
        
            I0_im = I0_im + ((sqrt(cos(theta))) .* (1+cos(theta))  .*  ...
            (sin((u/2)* (sin(theta/2).^2) / (sin(alpha/2)^2)))  .*  ...
            (besselj(0, sin(theta)/sin(alpha)*v))  .*  (sin(theta)))*gkw1(i);
        end
        %%
%         fprintf('%3.6f, %3.6f\n',v,I0_re)
        I0 = I0_re + 1i * I0_im;
%         disp(I0)
        patternLine(1,b) =I0;
        
%         disp(((x1+M*p1)^2+(x2+M*p2)^2)^0.5 *1e6)
    end
    pattern(a,:) = patternLine;    
%     disp(patternLine)
%     disp( ['Processing... Time used:',num2str(round(toc(timerVal))),' seconds']);
    waitbar((a-centerArea(1))/(centerPT-centerArea(1)),hwait,...
        ['Processing... ',num2str(round((a-centerArea(1))/(centerPT-centerArea(1))*100)),...
        '%... Time used:',num2str(round(toc(timerVal))),' seconds']);
end
pattern_temp = pattern;
pattern = Koi*pattern;
% close(gcp)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
waitbar((a-centerArea(1))/(centerPT-centerArea(1)),hwait,...
        ['Processing... ',num2str(round((a-centerArea(1))/(centerPT-centerArea(1))*100)),...
        '%... Integrating the PSF patterns...']);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
patternA = pattern( (1:centerPT), (1:centerPT) );
patternAt = fliplr(patternA);

pattern3D = zeros(size(pattern,1), size(pattern,2), 4);
pattern3D(:,:,1) = pattern;
pattern3D( (1:centerPT), (centerPT+1:end),1 ) = patternAt;
pattern3D(:,:,2) = rot90( pattern3D(:,:,1) , -1);
pattern3D(:,:,3) = rot90( pattern3D(:,:,1) , -2);
pattern3D(:,:,4) = rot90( pattern3D(:,:,1) , -3);

pattern = max(pattern3D,[],3);
% take the maximum values of all the elements at different positions among the 4 planes!!!!!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
close(hwait)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
psf = pattern;
% LFpsf = f1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%