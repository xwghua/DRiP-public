function NewRang = OrgGen(ParaRang)
%ORGGEN Summary of this function goes here
%   ***********************************************************************
%   This function generates the average radii of both inner and outer rings
%   randomly, and then joins the generated parameters.
%   Afterwards, it judges whether the generated parameters are qualifies
%   based on the limitations of the real pattern. If not, regenerate them.
%   ***********************************************************************

% MinAvgInn = 5;      MaxAvgInn = 1000;       % Inner ring Average radius minimum & maximum
% MinWidInn = 0;      MaxWidInn = 500;        % Inner ring width minimum & maximum
% MinAvgOut = 1000;       MaxAvgOut = 2200;   % Outer ring Average radius minimum & maximum
% MinWidOut = 0;      MaxWidOut = 500;        % Outer ring Average radius minimum & maximum

Act = 0;

while ~Act
    AvgInn = rand()*(ParaRang(2)-ParaRang(1))+ParaRang(1); % Inner ring radius average
    WidInn = rand()*(ParaRang(4)-ParaRang(3))+ParaRang(3); % Inner ring width
    AvgOut = rand()*(ParaRang(6)-ParaRang(5))+ParaRang(5); % Outer ring radius average
    WidOut = rand()*(ParaRang(8)-ParaRang(7))+ParaRang(7); % Outer ring width
    
    Act = (AvgInn-WidInn/2)>0 && (AvgInn+WidInn/2)<(AvgOut-WidOut/2) ...
        && (AvgOut-WidOut/2)<(ParaRang(6)+ParaRang(8)/2);
    % judgement factor; true = 1 while false = 0
    
    if ~Act     % show the info. of success and failure of generation
        disp(['AvgInn: ',num2str(AvgInn),...
            ' WidInn: ',num2str(WidInn),...
            ' AvgOut: ',num2str(AvgOut),...
            ' WidOut: ',num2str(WidOut),' ...failed/retry...']);
    else
        disp(['AvgInn:',num2str(AvgInn),...
            ' WidInn: ',num2str(WidInn),...
            ' AvgOut: ',num2str(AvgOut),...
            ' WidOut: ',num2str(WidOut),' ...SUCCEEDED!']);
    end  
end

NewRang = [AvgInn,WidInn,AvgOut,WidOut]; % combine the generated parameters

end

