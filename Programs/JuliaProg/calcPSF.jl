

################
# This file includes all the functions
# for computing PSF using CPU
# Developed by Xuanwen
# xwghua@gmail.com
###############

function fmax_complx(ma,mb)
    return ((ma+mb)+sign(abs(ma)-abs(mb))*(ma-mb))/2
end

function calcPSF(p1, p2, p3, fobj, NA, xspace, yspace, λ, M, n,boundary,calcMode=0)
    println("==Start PSF calculation==")
    ### param initial
    k = 2*pi*n/λ
    alpha = asin(NA/n)
    xlength = length(xspace)
    ylength = length(yspace)
    zeroline = zeros(Complex64,(1, ylength))

    pattern = zeros(Complex64,(self.xlength,self.ylength))
    centerPT = ceil(xlength/2)

    println("Calculation mode is",calcMode)
    if calcMode == 0
        calcOCTA(noundary)
        patternQUAT = fmax_complx()
        patternHALF = fmax_complx()
        PSF_field = 

    psf = 0;
    return psf
end
