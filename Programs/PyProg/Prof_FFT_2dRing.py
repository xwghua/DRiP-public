import numpy as np
from matplotlib import pyplot as plt
#get_ipython().magic(u'matplotlib inline')
x = np.arange(-30,30,0.025)
y = np.arange(-30,30,0.025)
X, Y = np.meshgrid(x, y)
distance = np.sqrt(X**2 + Y**2)
distance_d = np.sqrt((X-0)**2 + (Y-0)**2)


############# IMPORTANT PART FOR PARTICULAR PATTERN ##################
pattern = 0
pi = 3.141592653589697

# Add first ring
interval = 0.05
center = 0.8
pattern += (distance>center-interval)*(distance<center+interval)*(np.exp(1j*1))

# Add a second ring
interval = 0.05
center = 0.4
pattern += (distance>center-interval)*(distance<center+interval)*(np.exp(1j*1))

# Distance -> q - in the pol. coordinates
lamda = 632.8E-9
focus = 0.2
k = 2*pi/lamda
W0 = 1
gaussian_0 = np.exp(-(distance**2)/(W0**2))
gaussian_d0 = np.exp(-(distance_d**2)/(2*(W0**2)))*np.exp(-1j*k*focus-1j*k*(distance_d**2)/(4*(focus**2))+1j*pi/4)

# Make the field from the PSF
image = np.fft.ifftshift(np.fft.ifft2(pattern*gaussian_0))
image2 = np.fft.ifftshift(np.fft.ifft2(pattern*gaussian_d0))


########################################################################
# Change this parameter if you want to see more of the pattern on the focal plane.
window_size = 400
mask_size = 200 # analogous but for phase mask


#pattern = np.
plt.figure(1)
plt.subplot(321)
plt.imshow(np.angle(pattern)[1200-mask_size:1200+mask_size,1200-mask_size:1200+mask_size],cmap='gray',interpolation='None')
plt.title("SLM Pattern")

#plt.figure(2)
plt.subplot(323)
plt.imshow((np.abs(gaussian_0)**2)[1200-window_size:1200+window_size,1200-window_size:1200+window_size], cmap='hot',interpolation='None')
plt.title("Gaussian 1")


plt.subplot(324)
plt.imshow((np.abs(image)**2)[1200-window_size:1200+window_size,1200-window_size:1200+window_size], cmap='hot',interpolation='None')
plt.title("Output 1")

#plt.figure(3)
plt.subplot(325)
plt.imshow((np.abs(gaussian_d0)**2)[1200-window_size:1200+window_size,1200-window_size:1200+window_size], cmap='hot',interpolation='None')
plt.title("Gaussian 2")

plt.subplot(326)
plt.imshow((np.abs(image2)**2)[1200-window_size:1200+window_size,1200-window_size:1200+window_size], cmap='hot',interpolation='None')
plt.title("Output 2")

plt.show()
# uncomment if you want the phase
#plt.figure()
#plt.imshow(np.angle(image)[1200-window_size:1200+window_size,1200-window_size:1200+window_size], cmap='cubehelix',interpolation='none')
#plt.title("Focal plane phase")
