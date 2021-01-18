function [ Fitted,CoeffValue,GOF ] = GasFit( Res,DataX,DataY,Intensity,StartP )

% *************************************************************************
%
% *************************************************************************

FitMag = 1.0;
% X0=0;Y0=0;
GaussMod = @(P,X0,Y0,x,y)...      % P is related to the size of the peak, greater->narrower
    FitMag*exp( -( 1./P.*((x-X0).^2) + 1./P.*((y-Y0).^2) ));
% Opts = fitoptions( 'Method', 'NonlinearLeastSquares');


% [DataX,DataY]=meshgrid(-Res/2:1:Res/2,-Res/2:1:Res/2);
DataFit=[reshape(DataX,[],1),reshape(DataY,[],1),reshape(Intensity,[],1)];
[GasFit,GOF] = fit([DataFit(:,1),DataFit(:,2)],DataFit(:,3),GaussMod,'StartPoint',StartP);
Fitted = reshape(GasFit(DataFit(:,1),DataFit(:,2)),[Res,Res]);
CoeffValue = coeffvalues(GasFit);
disp('# -------------------------------------');
disp(['P X0 Y0: ',num2str(round(CoeffValue,3))]);
end

