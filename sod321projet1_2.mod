#Probleme maitre
param n integer >0;
param i_d integer >0;
param i_a integer >0;
param A_min integer >0;
param m integer >0;
param Z{1..n} integer >=0;
param R integer >0;
param X{1..n} integer >=0;
param Y{1..n} integer >=0;
param D{1..n, 1..n} integer >=0; #D[i,j] distance de l'aérodrome i à l'aérodrome j
param n_cycle integer >=0;
param M_cycle {1..n_cycle, 1..n} integer;
param b {1..n_cycle} integer;

var lambda{i in 1..n,j in 1..n : i<>j and D[i,j]<=R and j<>i_d and i<>i_a} binary;

minimize f :sum{i in 1..n, j in 1..n : i<>j and D[i,j]<=R and j<>i_d and i<>i_a} lambda[i,j]*D[i,j];

subject to
on_decolle_du_depart : sum{j in 1..n : i_d<>j and D[i_d,j]<=R}lambda[i_d,j]=1;
on_atterrit_a_l_arrivee : sum{j in 1..n : i_a<>j and D[i_a,j]<=R}lambda[j,i_a]=1;
on_visite_assez_d_aerodromes : sum{i in 1..n, j in 1..n : i<>j and D[i,j]<=R and j<>i_d and i<>i_a}lambda[i,j]>=A_min-1;
compte_region {t in 1..m} : 1<=sum{i in 1..n, j in 1..n : i<>j and D[i,j]<=R and j<>i_d and i<>i_a and (Z[i]=t or Z[j]=j)}lambda[i,j];
continuite {i in 1..n : i<>i_a and i<>i_d} : sum{j in 1..n : i<>j and D[i,j]<=R and j<>i_d and i<>i_a}lambda[i,j]=sum{j in 1..n : i<>j and D[i,j]<=R and i<>i_d and j<>i_a}lambda[j,i];
anticycle {k in 1..n_cycle} : sum {i in 1..n, j in 1..n : i<>j and D[i,j]<=R and j<>i_d and i<>i_a} M_cycle[k, i] * M_cycle[k, j] * lambda[i,j] <= b[k];

#---------------------------------------
#Sous-probleme
var S{1..n} binary;
var y{i in 1...n, j in 1..n : i<>j} >=0;

maximize cycletest:
sum {i in 1..n, j in 1..n : i<>j and D[i,j]<=R and j<>i_d and i<>i_a} y[i,j]*lambda[i,j] - sum{i in 1..n} S[i];

subj to 
minimal: sum{i in 1..n} S[i] >= 1;
coherence1{i in 1..n, j in 1..n : i<>j}: y[i,j] <= S[i];
coherence2{i in 1..n, j in 1..n : i<>j}: y[i,j] <= S[j];
