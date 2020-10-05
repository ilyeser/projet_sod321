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
#c1 : lambda[1,3]=1;
#c2 : lambda[2,5]=1;
#c3 : lambda[3,2]=1;
continuite1 {i in S1} : if i<>i_a and i<>i_d then sum{j in 1..n}lambda[i,j]=sum{j in 1..n}lambda[j,i];
continuite2 : gamma[i_d]=1;
continuite3 : gamma[i_a]=1+sum{i in 1..n, j in 1..n}lambda[i,j];
continuite4 {i in 1..n, j in 1..n} : gamma[j]>=gamma[i]+1-n*(1-lambda[i,j]);
#cycles {i in 1..n} : sum{j in 1..n}lambda[i,j]<=1;
