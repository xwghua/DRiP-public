# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Pass through the 4f Fourier system to get the camera image
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

using MAT
cd("C:\\Users\\Xuanwen\\Google Drive\\thesisproj\\PostOBJ")
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# %%%%% Convolution to get the image of microscope  %%%%%
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic()
STR = matread("bead1um8500_sf20nm.mat")
OTF = STR["otf_bead"]
OTF = convert(Array{Float64,2}, OTF)
STR = matread("PSF8500_sf2um.mat")
PSF = STR["PSF_res"]

display("Convoluting PSF with OTF......")
Img = conv2(OTF,PSF)

toc()
