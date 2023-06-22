# -*- coding: utf-8 -*-
"""
Created on Tue Sep 22 09:03:50 2020

@author: frany

"""

#################### library #####################
import numpy as np
from scipy.spatial import distance as dis
from scipy.io import loadmat,savemat
import argparse
import math

###################################################
def bayes_entropy2(X,r,tau):
    pos = 0
    Xm = []
    while pos+tau+1<X.shape[1]:
        Xm.append(X[:,pos:pos+tau])
        pos = pos+tau
    D = []
    for sim in Xm:
        if len(D)==0:
            D.append(sim.ravel())
        elif np.sum(dis.cdist(np.asarray(D),sim)<r)==False:
            D.append(sim.ravel())
    Xm = [i.ravel() for i in Xm]
    xx = np.asarray(Xm)
    d = dis.cdist(np.asarray(D),np.asarray(Xm))
    sig = np.median(d)
    simil = np.exp(-((d)**2)/(2*sig**2))
    #print(sum(simil.ravel()))
    Pd = np.mean(simil,axis=1)
    m  = np.mean(np.asarray([xx[:,i].reshape(xx[:,i].shape[0],1)*simil.T for i in range(xx.shape[1])]),axis=1).T
    var = np.mean(((dis.cdist(xx,m).T)**2)*simil,axis=1)
    d2 = dis.cdist(xx,m)
    simil2 = np.exp(-((d2)**2)/(2*var))
    Psd = np.mean(simil2,axis=0)
    Pds = Psd*Pd
    #print(len(D),len(Xm))
    E = -np.sum(Pds*np.log(Pds))/len(Xm)
    return E

###################### Main #######################
if __name__ == '__main__':
    ## Entradas de variables
    # parser = argparse.ArgumentParser(description = "Program")
    # parser.add_argument("Arch", help = "The potencials")
    # parser.add_argument("f1", help = "frecuency", nargs = "?")
    # args = parser.parse_args()
    # Stren = args.Arch   ## Carga de base de datos.
    #int(args.f1)
    Strength = loadmat('Strength_2_.mat')['Stren']
    freqs = [3,5,7,9]
    tau = 3  
    Entro = []
    for fr in range(0,4):
        X_ = np.asarray(Strength[0][freqs[fr]-1])
        Ent  = []
        for sub in range(0,50):
            Ent1 = []
            for ch in range(0,64):
                Data = np.array(X_[sub,ch,:]).reshape((1,-1))
                r = 0.2*np.std(Data)
                b_ = bayes_entropy2(Data,r,tau)
                if math.isnan(b_):
                    Ent1.append(0)
                else:
                    Ent1.append(b_)
            r = np.std(np.asarray(Ent1))
            # a_ = bayes_entropy2(np.asarray(Ent1).reshape((1,-1)),r,tau)
            a_ = np.mean(np.asarray(Ent1).reshape((1,-1)))
            if math.isnan(a_):
                Ent.append(0)
            else:
                Ent.append(a_)
        Entro.append(Ent)
    print('Done Entropy!')
    Entr = np.asarray(Entro)
print('Save Entropy')
savemat('Entropy_2_.mat', {'Entrpy':Entr})