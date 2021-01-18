function psf = calcPSF(p1, p2, p3, fobj, NA, xspace, yspace, lambda, M, n, centerArea)

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
for a=centerArea(1):centerPT
    patternLine = zeroline;
    x1 = xspace(a);
    parfor b=a:centerPT 
        x2 = yspace(b);          
        xL2normsq = (((x1+M*p1)^2+(x2+M*p2)^2)^0.5)/M;        
       
        v = k*xL2normsq*sin(alpha);    
        u = 4*k*(p3*1)*(sin(alpha/2)^2);
        Koi = M/((fobj*lambda)^2)*exp(-1i*u/(4*(sin(alpha/2)^2)));
        
        intgrand = @(theta) (sqrt(cos(theta))) .* (1+cos(theta))  .*  ...
            (exp((1i*u/2)* (sin(theta/2).^2) / (sin(alpha/2)^2)))  .*  ...
            (besselj(0, sin(theta)/sin(alpha)*v))  .*  (sin(theta));
        
%         intgrand_re = @(theta) (sqrt(cos(theta))) .* (1+cos(theta))  .*  ...
%             (cos((u/2)* (sin(theta/2).^2) / (sin(alpha/2)^2)))  .*  ...
%             (besselj(0, sin(theta)/sin(alpha)*v))  .*  (sin(theta));
%         
%         intgrand_im = @(theta) (sqrt(cos(theta))) .* (1+cos(theta))  .*  ...
%             (sin((u/2)* (sin(theta/2).^2) / (sin(alpha/2)^2)))  .*  ...
%             (besselj(0, sin(theta)/sin(alpha)*v))  .*  (sin(theta));
        warning off;
        I0 = integral(@(theta)intgrand (theta),0,alpha);  
%         I0_re = integral(@(theta)intgrand_re (theta),0,alpha);
%         I0_im = integral(@(theta)intgrand_im (theta),0,alpha);
%         I0 = I0_re + 1i * I0_im;
%         disp(Koi*I0)
        patternLine(1,b) =  Koi*I0;
    end
    pattern(a,:) = patternLine;    
    
%     disp( ['Processing... Time used:',num2str(round(toc(timerVal))),' seconds']);
    waitbar((a-centerArea(1))/(centerPT-centerArea(1)),hwait,...
        ['Processing... ',num2str(round((a-centerArea(1))/(centerPT-centerArea(1))*100)),...
        '%... Time used:',num2str(round(toc(timerVal))),' seconds']);
end

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