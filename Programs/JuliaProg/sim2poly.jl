using Deconvolution
#using PyPlot
#####################################
print("Program begins...... ")
tic()
println("Time in...")
########parameters setting###########
λ = 632.8E-9
k = 2*pi/λ
f = 200E-3
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
Rav1 = 2100E-6
dR1 = 50E-6
R1 = Rav1-dR1/2
R2 = Rav1+dR1/2
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
Rav2 = 4300E-6
dR2 = 200E-6
R3 = Rav2-dR2/2
R4 = Rav2+dR2/2
println("General parameters have been set...")
########range setting & ring mask###########
XYrange = linspace(-1E-0,1E-0,1000)         # 5000 shows the resolution of the mask
n = length(XYrange)
x = reshape(XYrange,1,n)
y = reshape(XYrange,n,1)
(X,Y) = (broadcast(+,x,zeros(n,1)),broadcast(+,y,zeros(1,n)))
ρ,ta,res2,res4 = zeros(n,n),zeros(n,n),zeros(n,n),zeros(n,n)
tb = ones(n,n)
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
print("Arranging double-ring mask... ")
for ii = 1:1:n
  for jj = 1:1:n
    ρ[jj,ii] = sqrt(x[ii]^2 + y[jj]^2)
    if (ρ[jj,ii]>R1 && ρ[jj,ii]<R2)||(ρ[jj,ii]>R3 && ρ[jj,ii]<R4)
      ta[jj,ii]=1
    elseif ρ[jj,ii]==R1 || ρ[jj,ii]==R2 || ρ[jj,ii]==R3 || ρ[jj,ii]==R4
      ta[jj,ii]=0.5
    end
  end
end
println("Completed!")
########random points setting###########
pn = 2
polypx,polypy = [rand(pn) rand(pn)],[rand(pn) rand(pn)]
println("Creating random points...NumOfPoints = ",pn," ...")
print("Build the central Gaussian and Bessel... ")
W0 = 3E-3;
gaussian0 = exp(-(ρ.^2)/(W0^2))
res = (fftshift(abs(fft(gaussian0)))).^2
res = res./maximum(res)
res3 = (fftshift(abs(fft(ta.*gaussian0)))).^2
res3 = res3./maximum(res3)
println("Completed!")
########Fourier Transformation###########
println("Loop starts... Total turns = ",pn," .")
for cont = 1:pn
  gaussian0d = exp(-(ρ.^2)/(W0^2)).*exp(-1*im*k*Y*polypx[cont]-1*im*k*X*polypy[cont])
  res2 = res2+(fftshift(abs(fft(gaussian0d)))).^2
  res4 = res4+(fftshift(abs(fft(ta.*gaussian0d)))).^2
  println("The ",cont,"th turn has completed...")
end
print("Loop finishes... Organizing data... ")
res2 = res2./maximum(res2)
restot = res + res2
res4 = res4./maximum(res4)
restot2 = res3 + res4
println("Completed!")
print("Deconvolution step starts... Setting PSF... ")
PSF = res3
print("Completed!")
imobj = wiener(restot2,PSF,0)

toc()
