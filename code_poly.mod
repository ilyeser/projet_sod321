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


var lambda{i in 1..n,j in 1..n:i<>j and D[i,j]<=R and j<>i_d and i<>i_a} binary;
var gamma{1..n} integer >=0;

minimize f :sum{i in 1..n, j in 1..n : i<>j and D[i,j]<=R and j<>i_d and i<>i_a} lambda[i,j]*D[i,j];

subject to
on_decolle_du_depart : sum{j in 1..n:j<>i_d and D[i_d,j]<=R}lambda[i_d,j]=1;
on_atterrit_a_l_arrivee : sum{j in 1..n:i_a<>j and D[i_a,j]<=R}lambda[j,i_a]=1;
on_visite_assez_d_aerodromes : sum{i in 1..n, j in 1..n:i<>j and D[i,j]<=R and j<>i_d and i<>i_a}lambda[i,j]>=A_min-1;
compte_region {t in 1..m} : 1<=sum{i in 1..n, j in 1..n:i<>j and D[i,j]<=R and j<>i_d and i<>i_a and (Z[i]=t or Z[j]=t)}lambda[i,j];
continuite1 {i in 1..n:i<>i_a and i<>i_d} : sum{j in 1..n:i<>j and D[i,j]<=R and j<>i_d and i<>i_a}lambda[i,j]=sum{j in 1..n:i<>j and D[i,j]<=R and i<>i_d and j<>i_a}lambda[j,i];
continuite2 : gamma[i_d]=1;
continuite3 : gamma[i_a]=1+sum{i in 1..n, j in 1..n:i<>j and D[i,j]<=R and j<>i_d and i<>i_a}lambda[i,j];
continuite4 {i in 1..n, j in 1..n:i<>j and D[i,j]<=R and j<>i_d and i<>i_a} : gamma[j]>=gamma[i]+1-n*(1-lambda[i,j]);
