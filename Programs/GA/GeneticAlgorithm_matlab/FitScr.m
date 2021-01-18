function [ Score ] = FitScr( Fitted,Eff,GOF,Intensity )
%FITSCR Summary of this function goes here
% *************************************************************************
% 
% *************************************************************************

Score.Res = sqrt(2/Eff(1));
Score.GOF = GOF.adjrsquare;
% Score.Constr = sqrt(sum(sum(Fitted)) \ (sum(sum(Intensity))-sum(sum(Fitted))));
Intside = Intensity(ceil(end/2),ceil(end/2+1):end);
[pks, locs] = findpeaks(Intside);
Score.Constr = sum(pks(2:10)) ^2;

% Score.Total = Score.Res ; %+Score.Constr;
Score.Total = Score.Res - Score.Constr;
% Score.Total = Score.Total;

disp(['# Main = ',num2str(round(Score.Res,2)),...
    '; GOF = ',num2str(round(GOF.adjrsquare,2)),...
    '; Constr = ',num2str(round(Score.Constr,2)),...
    '; Scr = ',num2str(round(Score.Total,2))]);
end
