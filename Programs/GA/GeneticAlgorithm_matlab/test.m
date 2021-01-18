% Parent = Record(1,:);
% SLMBLK = zeros(1700*2.5);       % set a blank pattern as a base
% Incident = ones(1700*2.5);      % set incident light FIELD

% #######################################################################
figure(200),
SLM = PhaPat(Record(791,:),stop,rho);
PSF = FocPsf(bead,SLM);
Intensity = (abs(PSF)).^2;
Intensity = Intensity/max(max(Intensity));
subplot(2,2,1),plot(x*100,Intensity(850*2.5,:)),title('PSF Better');
subplot(2,2,3),imshow(SLM),title('SLM Best');
% subplot(1,2,1),plot(x*200,Intensity(850*2.5+1,:)),title('PSF Best');

SLM = PhaPat(Record(1,1:4),stop,rho);
% SLM = PhaPat([600 400 1100 400],stop,rho);
PSF = FocPsf(bead,SLM);
Intensity = (abs(PSF)).^2;
Intensity = Intensity/max(max(Intensity));
subplot(2,2,2),plot(x*100,Intensity(850*2.5,:)),title('PSF Other');
subplot(2,2,4),imshow(SLM),title('SLM Other');
% subplot(1,2,2),plot(x*200,Intensity(850*2.5+1,:)),title('PSF Other');

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%% Gaussian fitting %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

StartP = [0.001,0,0];
SLM = PhaPat(Record(1,1:4),stop,rho);
PSF = FocPsf(bead,SLM);
Intensity = (abs(PSF)).^2;
Intensity = Intensity/max(max(Intensity));
[Fitted,eff,GOF] = GasFit(length(x(1826:2425)),X(1826:2425,1826:2425),...
    Y(1826:2425,1826:2425),Intensity(1826:2425,1826:2425),StartP);
% disp([eff,GOF.adjrsquare])
Score = FitScr(Fitted,eff,GOF,Intensity(1826:2425,1826:2425));
figure(404);
plot(x(1826:2425),Intensity(ceil(end/2),1826:2425));
hold on
plot(x(1826:2425),Fitted(ceil(end/2),:))

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%% High-level side lobes %%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SLM = PhaPat(Record(1,:),stop,rho);
PSF = FocPsf(bead,SLM);
Intensity = (abs(PSF)).^2;
Intensity = Intensity/max(max(Intensity));
Intside = Intensity(850*2.5,ceil(end/2+1):end);
[pks, locs] = findpeaks(Intside);
sideh = sum(pks(2:10))
figure(500),plot(100*x(ceil(end/2+1):end),Intside);
hold on 
plot(17000/4249*(locs-1)+1,pks);
