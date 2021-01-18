function [ Pattern ] = PhaPat( Para,Base,Distance )
%PHAPAT Summary of this function goes here
%   ***********************************************************************
%   This function generates pattern based on the parameters
%   The pattern consists of a Base and a Optical Transmit Function (OTF)
%   Base sets the scale of the pattern and the primitive conditions of the
%   pattern. The general base is a "zerolized" matrix.
%   ***********************************************************************

AvgInn = Para(1);       % the inner average radius of the ring mask
WidInn = Para(2);       % the width of the inner ring of the mask
AvgOut = Para(3);       % the outer average radius of the ring mask
WidOut = Para(4);       % the width of the inner ring of the mask

R1 = AvgInn-WidInn/2;   % the inner radius of the inner ring
R2 = AvgInn+WidInn/2;   % the outer radius of the inner ring
R3 = AvgOut-WidInn/2;   % the inner radius of the outer ring
R4 = AvgOut+WidOut/2;   % the outer radius of the outer ring

% LengX = length(Base(1,:));      % horizontal length of the pattern
% LengY = length(Base(:,1));      % vertical length of the pattern
% [X,Y] = meshgrid(1:1:LengX,1:1:LengY);  % extend the axes to plane

% Distance = sqrt((X-LengX/2).^2+(Y-LengY/2).^2);     
% distance of every element from the center of the pattern
% this treat the center of the pattern as the original point
Trans = (Distance>=R1).*(Distance<=R2)+(Distance>=R3).*(Distance<=R4);  % Generate the OTF
% Trans = abs(Trans*exp(1i*1));       %transform the OTF from logical data to double data
Pattern = Base .* Trans;     % generate the pattern with the combination of Base and OTF

end

