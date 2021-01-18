import os
import numpy as np
from scipy import io

os.chdir('C://Users//Xuanwen//Desktop//hua1201')

num_group = 21;
num_indvd = 21;
for ii in range(num_group):
    for jj in range(num_indvd):
        if jj<10:
            readpath = ''.join(['e',str(ii+1),'//01Dec2016_00',str(jj),'.npy'])
            writpath = ''.join(['e',str(ii+1),'//01Dec2016_00',str(jj),'.mat'])
        else:
            readpath = ''.join(['e',str(ii+1),'//01Dec2016_0',str(jj),'.npy'])
            writpath = ''.join(['e',str(ii+1),'//01Dec2016_0',str(jj),'.mat'])
            
        data_a=np.mat(np.load(readpath))
        dataa=1.0*data_a/np.amax(data_a)
        io.savemat(writpath, {'matrix': dataa})



