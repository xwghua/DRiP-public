'''Supplemental
This is an evolutionary algorithm for optimizing a phase mask to be used for
generating a helicon point spread function.
Text and code by Bryce Schroeder. Some code also developed by Zhen Zhu & Xuanwen.'''
print('*********************************************************')
print('Evolutionary Algorithm for PSF Optimization','(C) 2016 ')
print('by Bryce Schroeder & Xuanwen Hua, for Shu Jia\'s lab, SBU')
print('sites.google.com/site/thejialab/')
print('bryce.schroeder@gmail.com   www.bryce.pw/')
print('xwghua@gmail.com   xwghua.wordpress.com')
print('*********************************************************')
import numpy as np
import matplotlib
print ('The version of matplotlib is',matplotlib.__version__)
import matplotlib.pyplot as plt
import scipy.optimize as sopt
import random
import bisect
import copy
import time
start_time = time.time()
########## Object-Organism #############################################
'''
We define our organism in an object-oriented fashion, first with the 
general case, and then with a subclass specific to the helicon PSF 
which we are optimizing.
'''
class Organism(object):
    '''Represents an individual in the population.
       Subclasses need to define breed_from, random_mutation and generate_random.'''
    serial_number = 0
    valid = False
    MUTATION_CHANCE = 40 # Mutation chance for new organism. 
    def __init__(self, parents=None):
        Organism.serial_number += 1
        self.valid = False
        self.score = None
        self.serial_number = Organism.serial_number
        '''Generate a new organism.
           If a list of other organisms is passed as
           the parameter 'parents', breed the new organism from them.
           Otherwise, generate the new organism de novo.'''
        self.genes = None
        self.paramenters = [0,0,0,0]
        if parents:
            self.breed_from(parents)
            ''' Organisms can have many mutations, or none;
            mutations are not the only source of genetic diversity
            in the population: the breeding process creates new 
            combinations of gene analogs,
            and randomly generated solutions can be injected
            into each generation as well to provide "fresh blood." '''
            while random.randint(0,100) < self.MUTATION_CHANCE:
                self.random_mutation()
        else:
            self.generate_random()
########## Organism-ModHeliconOrganism #############################################
class ModHeliconOrganism(Organism):
    valid = False
    #************************
    MIN_AVG_I =    5 #      *
    MAX_AVG_I = 1000 ##     *
    MAX_WID_I =  500 #      *
    #************************
    MIN_AVG_O = 1000 #      *
    MAX_AVG_O = 2200 ##     *
    MAX_WID_O =  500 #      *
    #************************
    score_gof = 1000.0
    score_s = 1000.0
    score_ar = 1000.0
    MUTATION_OFFSET_MAGNITUDE = 5.00 # 5 how big is a phase offset mutation, maximally? +/-
    
    def pretty_print_parameters(self):
        '''Return a good visual representation of the parameters.'''
        return ' '.join(["%+.2f"%n_off for n_off in self.parameters])
    
    def generate_random(self):
        '''Generate this organism's parameters _de novo_.'''
        # Generate a list of (mode, offset) tuples, which will be the parameters.
        self.parameters = [random.random()*(self.MAX_AVG_I-self.MIN_AVG_I)+self.MIN_AVG_I,random.random()*(self.MAX_WID_I),random.random()*(self.MAX_AVG_O-self.MIN_AVG_O)+self.MIN_AVG_O,random.random()*(self.MAX_WID_O)]
        #self.parameters = [random.random()*(self.MAX_WID_I*2)-self.MAX_WID_I]
        #self.parameters = [random.random()*(self.MAX_AVG_O*2)-self.MAX_AVG_O]
        #self.parameters = [random.random()*(self.MAX_WID_O*2)-self.MAX_WID_O]
        
    def breed_from(self, parents):
        '''Create a new organism with a combination of traits from the parents.'''
        # FIXME: Currently, only asexual reproduction is supported
        self.parameters = copy.copy(random.choice(parents).parameters)
        
    def random_mutation(self):
        '''Make a single mutation to this organism.'''
        which = random.randint(0, len(self.parameters)-1)
        self.parameters[which] += random.random()*self.MUTATION_OFFSET_MAGNITUDE*2 - self.MUTATION_OFFSET_MAGNITUDE
        self.parameters[which] = min(max(self.MIN_PITCH, self.parameters[which]), self.MAX_PITCH)
        return 'ofs'
        
    def phase_pattern(self, fx, fy,magrd):
        '''Render the phase modulation pattern to be imposed on the Fourier plane.'''
        act = 0
        while act==0:
            a,b,c,d = [random.random()*(self.MAX_AVG_I-self.MIN_AVG_I)+self.MIN_AVG_I,random.random()*(self.MAX_WID_I),random.random()*(self.MAX_AVG_O-self.MIN_AVG_O)+self.MIN_AVG_O,random.random()*(self.MAX_WID_O)]
            # a : R_avg_inner
            # b : dR_inner
            # c : R_avg_outer
            # d : dR_outer
            act = (a+b/2 < c-d/2)*(0<a-b/2)*(a<c)*(b>d)
            if act == 0:
                print 'a:%.2f b:%.2f c:%.2f d:%.2f ...failed...Retry...'%(a,b,c,d)
            else:
                print 'A possible set of parameters are :',a,b,c,d,'succeeded......'
        size = 2 #((size+10)/(20))*0.25 + (0.50-0.125)
        x0 = 0.5
        y0 = 0.5
        #print "x0", x0, np.min(fx), np.max(fx)
        #print "y0", y0, np.min(fy), np.max(fy)
        #if not HeliconOrganism.hasattr('distance'): HeliconOrganism.distance = np.sqrt(fx**2 + fy**2)
        rd = magrd*np.sqrt((fx)**2 + (fy)**2)
        #itch = a*r**3 + b*r**2 + c*r +d
        #pitch = b*r**2 + c*r + d
        pattern = 0
        pattern += ((rd>a-b/2)*(rd<a+b/2)+(rd>c-d/2)*(rd<c+d/2))*(np.exp(1j*1))          
        print 'Pattern generation completed......'    
        return pattern

########## Test pretty_print_parameters ###########################################
'''h = ModHeliconOrganism()
print ('1st', h.pretty_print_parameters()) #ossible_modes

for _ in range(10):
    mutation_type = h.random_mutation()
    print (mutation_type, h.pretty_print_parameters())'''
########## Test phase_pattern #####################################################
'''fx,fy = np.meshgrid(np.linspace(-1, 1, 4000), np.linspace(-1, 1, 4000))
plt.figure(figsize=(16,8))

for i in range(0,2*2):
    h = ModHeliconOrganism()
    #h.parameters = [[i-6,0]]
    
    plt.subplot(2,2,i+1)
    plt.imshow(np.angle(h.phase_pattern(fx, fy,4000/2)),
               cmap='gray', interpolation='none', vmin=-np.pi, vmax=np.pi)
    plt.xlabel(h.pretty_print_parameters())

plt.show()'''
########## Object-Score INDEPENDENT ####################################
MAX_SCORE = 1000.0
'''# Here we define our generalized FITNESS FUNCTION, which will be used
# to evaluate the fitness of the population'''
class Scorer(object):
    '''# The scorer will encapsulate the scoring criteria
    # and associated constants.'''
    SIZE=30.0
    TARGET_SIZE = 0.0
    ''' Score weight for the goodness of the gaussian fit
    as measured by mean square error'''
    GOF_WEIGHT = 13750.0
    AR_WEIGHT = 5.0
    SIZE_WEIGHT = 100
    def __init__(self, resolution=600):
        '''Set up a new scorer. Higher resolutions yield somewhat better 
           results but everything takes longer to compute.'''
        self.resolution = resolution
        self.fx, self.fy = np.meshgrid(np.linspace(-1, 1, resolution), 
                                       np.linspace(-1, 1, resolution))
    def focal_plane_psf(self, pattern):
        return np.fft.ifftshift(np.fft.ifft2(pattern))
    
    def phase_pattern(self, organism):
        return organism.phase_pattern(self.fx, self.fy,self.resolution/2)
    
    def gaussian_fit(self, intensity):
        print 'Fitting......This procedure may take a long time...'
        def elliptical_gaussian(xy, amplitude, x0, y0, wx, wy, theta):
            x,y = xy
            p1 = np.cos(theta)**2/(2*wx**2) + np.sin(theta)**2/(2*wy**2)
            p2 = np.sin(theta)**2/(2*wx**2) + np.cos(theta)**2/(2*wy**2)
            p3 = -np.sin(2*theta)/(4*wx**2) + np.sin(2*theta)/(4*wy**2)
            result = (amplitude*np.exp(- (  p1*((x-x0)**2) 
                                 + p2*((y-y0)**2)
                                 + 2*p3*(x-x0)*(y-y0))))
            result = np.abs(result.ravel())
            return result

            #return background + amplitude*np.exp( 
            #      (x0*np.cos(theta) + y0*np.sin(theta))**2/wx**2  
            #    - (x0*np.sin(theta) - y0*np.cos(theta))**2/wy**2 
            #    )
        guess = (0.001, 0, 0, -0.010, -0.010, 0.0)
        #represent(mag, x0,  y0,  wx, wy, theta)
        try:
            popt, pcov = sopt.curve_fit(elliptical_gaussian, (self.fx,self.fy), 
                                        intensity.ravel(), p0=guess)
        except RuntimeError:
            return None,guess
        
        fitted = elliptical_gaussian((self.fx,self.fy), *popt).reshape(*intensity.shape)
        return fitted, popt
    
    def score(self, organism):
        '''Total score and weighted component scores are returned, as well as images'''
        if organism.score is not None:
            return organism.score, (organism.score_gof, organism.score_ar, organism.score_s), (None,None,None,None)
            
        pattern = self.phase_pattern(organism)
        fp = self.focal_plane_psf(pattern)
        intensity = np.abs(fp**2)
        vmax,vmin = np.max(intensity), np.min(intensity)
        fitted, (amplitude, x0, y0, wx, wy, theta) = self.gaussian_fit(intensity)
        print  "**", amplitude, wx, wy
        if fitted is None: return MAX_SCORE, (MAX_SCORE,MAX_SCORE,MAX_SCORE), (pattern, fp, intensity, fitted)
        # Mean square error of the gaussian fit
        nm_fit = (fitted - vmin)/(vmax-vmin)
        nm_in  = (intensity - vmin)/(vmax-vmin)
        score_goodness_of_fit = self.GOF_WEIGHT*np.sum((nm_fit-nm_in)**2)#/self.resolution**2
        
        # Score for the aspect ratio
        score_aspect_ratio = self.AR_WEIGHT*((min(np.abs(wx),np.abs(wy))/max(np.abs(wx),np.abs(wy))) - 1.0)**2
        
        # Score for the size
        score_size = self.SIZE_WEIGHT*(max(np.abs(wx),np.abs(wy)) - self.TARGET_SIZE)**2
        
        organism.score = score_goodness_of_fit + score_aspect_ratio + score_size
        organism.score_gof = score_goodness_of_fit
        organism.score_ar = score_aspect_ratio
        organism.score_s = score_size
        
        return organism.score, (
            score_goodness_of_fit, score_aspect_ratio, score_size), (
                pattern, fp, intensity, fitted)
    
    def elitism(self, population, elite_cut, subscore_cut):
        elite = sorted(population, key=lambda o: o.score)[:elite_cut]
        for key in [lambda o: o.score_gof, lambda o: o.score_ar, lambda o: o.score_s]:
            elite.extend(sorted(population, key=key)[:subscore_cut])
        return elite
    
    def statistics(self, population):
        ''' expects a fully scored & validated population '''
        valids = filter(lambda a: a.valid, population)
        valid_fraction = len(valids)/float(len(population))
        scores, scores_gof, scores_ar, scores_s = map(np.asarray, 
                                                      zip(*[(a.score, a.score_gof, a.score_ar, a.score_s) for a in valids]))
        return (valid_fraction, 
                np.min(scores), np.min(scores_gof), np.min(scores_ar), np.min(scores_s),
                np.mean(scores), np.mean(scores_gof), np.mean(scores_ar), np.mean(scores_s),
                )
########## PSF Generation Test ########################################################
'''s = Scorer(resolution=4500)
plt.figure(figsize=(16,8))
vsize=40
for i in range(6):
    h = ModHeliconOrganism()
    plt.subplot(2,6, i+1)
    ph = s.phase_pattern(h)
    plt.imshow(np.angle(ph), cmap='gray', interpolation='none', vmin=-np.pi, vmax=np.pi)
    
    psf = s.focal_plane_psf(ph)
    plt.subplot(2,6, i+7)
    plt.imshow(np.abs(psf**2)[round(s.resolution/2-vsize):round(s.resolution/2+vsize),round(s.resolution/2-vsize):round(s.resolution/2+vsize)], cmap='hot', interpolation='none')

    #plt.subplot(3,4, i+9)
    #plt.imshow((np.angle(psf)[s.resolution/2-vsize:s.resolution/2+vsize,s.resolution/2-vsize:s.resolution/2+vsize]), cmap='cubehelix', interpolation='none')
plt.tight_layout()
plt.show()'''
########## Scoring Algorithm Test ####################################################
s = Scorer(6000)
plt.figure(figsize=(16,8))
vsize=40
RNDS = 6
print 'Enter the loop......'
for i in range(RNDS):
    score, (s_gof, s_ar, s_s), (pattern, fp, intensity, fitted) = s.score(ModHeliconOrganism())
    vmax,vmin = np.max(intensity), np.min(intensity)
    print 'Generating the %dth set of images......'%i
    plt.subplot(3,RNDS, i+1)
    plt.imshow(intensity[round(s.resolution/2-vsize):round(s.resolution/2+vsize),round(s.resolution/2-vsize):round(s.resolution/2+vsize)], cmap='hot', vmax=vmax, vmin=vmin)
    plt.xlabel("Score %.2f"%score)
    
    plt.subplot(3,RNDS, i+1+RNDS)
    plt.imshow(fitted[round(s.resolution/2-vsize):round(s.resolution/2+vsize),round(s.resolution/2-vsize):round(s.resolution/2+vsize)], cmap='hot', vmax=vmax, vmin=vmin)
    plt.xlabel("AR %.2f Size %.2f GOF %.2f"%(s_ar, s_s, s_gof))

    plt.subplot(3,RNDS, i+1+2*RNDS)
    plt.imshow(np.angle(pattern), cmap='gray', interpolation='none', vmin=-np.pi, vmax=np.pi)
    #plt.imshow(np.angle(pattern)[round(s.resolution/2-vsize):round(s.resolution/2+vsize),round(s.resolution/2-vsize):round(s.resolution/2+vsize)], cmap='hot', vmax=vmax, vmin=vmin)
    #plt.xlabel(''%())
    
print "------Time comsumed: %s seconds------"%(time.time()-start_time)
plt.tight_layout()
plt.show()
