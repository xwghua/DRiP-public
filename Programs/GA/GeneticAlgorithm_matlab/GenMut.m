function [ NewPara ] = GenMut(ParaRang,Para,MutMag)
%GENMUT Summary of this function goes here
%   ***********************************************************************
%   This function generates the mutation of the pattern parameters
%   randomly, and then generates new parameters.
%   Afterwards, it judges whether the generated parameters are qualifies
%   based on the limitations of the real pattern. If not, regenerate them.
%   ***********************************************************************

Act = 0;
NewPara = Para;
while ~Act
    Leng = length(Para);    % acquire the length of the array of Parameters
%     Which = randi(Leng);        % select randomly which parameter to mutate
    NewPara = Para+rand(1,Leng)*MutMag*2-MutMag;    % MAKE MUTATION
    
    Act = (NewPara(1)-NewPara(2)/2)>0 ...
        && (NewPara(1)+NewPara(2)/2)<(NewPara(3)-NewPara(4)/2) ...
        && (NewPara(3)+NewPara(4)/2)<(ParaRang(6)+ParaRang(8)/2) ...
        && (NewPara(2)>0) && (NewPara(4)>0);
    % judgement factor; true = 1 while false = 0
    
    if ~Act     % show the info. of success and failure of generation
        disp(['*Mut.Fail* ',num2str(NewPara),' X']);
    else
        disp(['ofs ',num2str(NewPara)]);
    end
end

end

