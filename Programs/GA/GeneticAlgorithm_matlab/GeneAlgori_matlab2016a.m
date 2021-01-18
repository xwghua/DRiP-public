% This is the matlab version of Genetic Algorithm
% Modified by Xuanwen Hua based on Bryce & Zhen's version program
% This program support parallel computing, but does not support GPU computing
% If having any question, feel free to contact me via xwghua@gmail.com
% More Info. can be found on my homepage xwghua.wordpress.com
% **********************************************************************
% Sub functions definition: (details are in every sub-func file)
% OrgGen(self)		//generate a strcture containing all elements an organism requires
% GenMut(self,parent)		//make a single mutation to parent
% PhaPat(self,fx,fy)		//generate a pattern based on self and mutations
% FocPsf(self,pattern)		//generate PSF on the focal plane of the Fourier sys.
%							//PSF is the field profile instead of intensity, sqr b4 using
% GasFit(self,intensity)	//Gaussian fitting of PSF INTENSITY
% FitScr(self,intensity,fitted)		//Score the fitting with original intensity


% ~~~~~~~~~~~~~~~~~~~ Heading ~~~~~~~~~~~~~~~~~~~~~~~~~
clear,clc
disp('* The program of Genetic Algorithm begins......')
disp('Note: latest modification was on 7th, Nov.')
cd(fileparts(mfilename('fullpath'))) % dir in lab computer or personal computer
tic
%% ==============Initiation of variables=============
MinAvgInn = 0;      MaxAvgInn = 1500;       % Inner ring Average radius minimum & maximum
MinWidInn = 0;      MaxWidInn = 500;        % Inner ring width minimum & maximum
MinAvgOut = 500;       MaxAvgOut = 1500;   % Outer ring Average radius minimum & maximum
MinWidOut = 0;      MaxWidOut = 500;        % Outer ring Average radius minimum & maximum
ParaRang = [MinAvgInn,MaxAvgInn,MinWidInn,MaxWidInn,...
            MinAvgOut,MaxAvgOut,MinWidOut,MaxWidOut];
MutationMag = 20.0;                         % the maximum of a phase offset mutation
MutationSeq = [];
% ----------------------set bead---------------------------
scale = 2.5;
x = linspace(-85,85,1700*scale); % um / res:40nm
y = linspace(-85,85,1700*scale); % um / res:40nm
[X,Y] = meshgrid(x,y);
% mu = [0,0];
% bsize = 1;
% sigma = [(bsize/2)^2,0;0,(bsize/2)^2];
% dist = mvnpdf([X(:),Y(:)],mu,sigma);
STR = load('beadimg4250_sf4um.mat');
bead = STR.Img;
% --------------------set ring mask------------------------
magnitude = 80*scale;
rho = sqrt((X*magnitude).^2+(Y*magnitude).^2);
% tA = (rho>=R1).*(rho<=R2)+(rho>=R3).*(rho<=R4);
r_stop = 2*1.45/sqrt(1.515^2-1.45^2)*1000; % um
stop = (sqrt((X*magnitude).^2+(Y*magnitude).^2))>-1;
%% ==========Genetic Algorithm -- breeding==========
NumOfGen = 500;
NumOfInd = 4;
Record = [];
StartP = [0.001,0,0];
FitRang1 = 1826;
FitRang2 = 2425;

% Parent = OrgGen(ParaRang);
% Parent = [600 350 1100 350];
global Parent_temp
Parent = Parent_temp;
MutMagFine = MutationMag;
TotalMax = 0;
ScrList = [1.0 2.0 3.0 4.0 5.0 6.0]-0.5;
% parpool                   % start parallel pool
fprintf('\n parpool starts......\n ************************************\n');
% hwait = waitbar(0,'GA processing......');
for iGen = 1:1:NumOfGen
    disp(['To generate the ',num2str(iGen),'st/nd/rd/th generation...']);
    if TotalMax>=ScrList(1) && TotalMax<ScrList(2)
        MutMagFine = 0.8*MutationMag;
    elseif TotalMax>=ScrList(2) && TotalMax<ScrList(3)
        MutMagFine = 0.6*MutationMag;
    elseif TotalMax>=ScrList(3) && TotalMax<ScrList(4)
        MutMagFine = 0.4*MutationMag;
    elseif TotalMax>=ScrList(4) && TotalMax<ScrList(5)
        MutMagFine = 0.2*MutationMag;
    elseif TotalMax>=ScrList(5) && TotalMax<ScrList(6)
        MutMagFine = 0.1*MutationMag;
    elseif TotalMax>=ScrList(6)
        MutMagFine = 0.05*MutationMag;
    end
    parfor iInd = 1:1:NumOfInd
        MutTemp = GenMut(ParaRang,Parent,MutMagFine);
        SLM = PhaPat(MutTemp,stop,rho);
        PSF = FocPsf(bead,SLM);
        Intensity = (abs(PSF)).^2;
        Intensity = Intensity/max(max(Intensity));
        disp(['PSF generated...Fitting... (Gen ',...
            num2str(iGen),'/',num2str(NumOfGen),',Ind ',...
            num2str(iInd),'/',num2str(NumOfInd),')']);
        [Fitted,Eff,GOF] = GasFit(length(x(FitRang1:FitRang2)),...
            X(FitRang1:FitRang2,FitRang1:FitRang2),...
            Y(FitRang1:FitRang2,FitRang1:FitRang2),...
            Intensity(FitRang1:FitRang2,FitRang1:FitRang2),StartP);
        Score = FitScr(Fitted,Eff,GOF,...
                        Intensity(FitRang1:FitRang2,FitRang1:FitRang2));
        
        Record = [Record;[MutTemp,Score.Constr,Score.Res,0]];
    end
    [Maxi,Indx] = max(Record(NumOfInd*iGen-NumOfInd+1:NumOfInd*iGen,6));
    Parent = Record(NumOfInd*iGen-NumOfInd+Indx,1:4);
    Record(NumOfInd*iGen-NumOfInd+Indx,end) = 1;
    TotalMax = Record(NumOfInd*iGen-NumOfInd+Indx,end-1);
%     waitbar(iGen/NumOfGen,hwait,['GA processing......',num2str(round(iGen/NumOfGen*100,3)),'% Completed!']);
    disp(['$$$--- Time cost: ', num2str(round(toc)),'seconds ---$$$']);
end
% delete(gcp)
% close(hwait)
%% ==========Presenting -- Plot the results and show==========

%% ~~~~~~~~~~~~~~~~~~~ Ending ~~~~~~~~~~~~~~~~~~~~~~~~~
fprintf('\n parpool ends......Total time: %f secs',toc);