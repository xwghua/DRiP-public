function [ PSF ] = FocPsf( Incident,Pattern )
%FOCPSF Summary of this function goes here
%   ***********************************************************************
%   This function generates the PSF based on the pattern.
%   The PSF is NOT the function of INTENSITY!!!
%   So when use, DO remember to SQUARE!!!
%   ***********************************************************************

ipt = fftshift(fft2(fftshift(Incident)));

% Int = abs(ipt).^2; Int = Int/max(max(Int)); figure(201),imshow(Int);

PSF = fftshift(fft2(fftshift(ipt.*Pattern)));


end

