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
param M_cycle {1..n_cycle, 1..n, 1..n} integer;
param b {i in 1..n_cycle} integer;
set T = 1..n;
set S1=T diff {i_a, i_d};
set S2=T diff {i_d};



var beta{1..m} binary;
var lambda{1..n,1..n} binary;
var gamma{1..n} integer >=0;

minimize f :sum{i in 1..n, j in 1..n} lambda[i,j]*D[i,j];

subject to
on_decolle_du_depart : sum{j in 1..n}lambda[i_d,j]=1;
c_est_bien_le_premier : sum{j in 1..n}lambda[j,i_d]=0;
on_atterrit_a_l_arrivee : sum{j in 1..n}lambda[j,i_a]=1;
c_est_bien_le_dernier : sum{j in 1..n}lambda[i_a,j]=0;
on_visite_assez_d_aerodromes : sum{i in 1..n, j in 1..n}lambda[i,j]>=A_min-1;
carburant {i in 1..n} : sum{j in 1..n}lambda[i,j]*D[i,j]<=R;
compte_region {t in 1..m} : beta[t]<=sum{i in 1..n, j in 1..n}lambda[i,j]*((t-Z[i]+2)/(4*n^2*(t-Z[i])+1)+(t-Z[j]+2)/(4*n^2*(t-Z[j])+1));
visiter_les_regions : sum{t in 1..m}beta[t]=m;
#pas_de_sur_place {i in 1..n} : lambda[i,i] = 0;
continuite {i in S1} : if i<>i_a and i<>i_d then sum{j in 1..n}lambda[i,j]=sum{j in 1..n}lambda[j,i];
anticycle {i in 1..n_cycle} : sum {k in 1..n, l in 1..n} M_cycle[i, k, l] * lambda[k,l] <= b[i];

#---------------------------------------
#Sous-probleme
var S{1..n, 1..n} binary;

maximize cycletest:
sum {i in 1..n, j in 1..n} S[i,j]*lambda[i,j] - sum{k in 1..n} S[k,k];

subj to coherence {i in 1..n, j in 1..n}: 2*S[i,j] <= S[i,i] + S[j,j];
minimal: sum{i in 1..n, j in 1..n} S[i,j] >= 1;
#uniquement_chemin_valide1{i in 1..n, j in 1..(i-1)}: S[i,j] <= lambda[i,j];
#uniquement_chemin_valide2{i in 1..n, j in (i+1)..n}: S[i,j] <= lambda[i,j];
