#!/usr/bin/env python3
# -*- coding: utf-8 -*-

def separer(chaine):
    i = 0
    j = 0
    res = []
    while j < len(chaine):
        while j < len(chaine) and chaine[j] != " ":
            j = j+1
        res = res+ [chaine[i:j]]
        i = j+1
        j = j+1
    return res

def app(l,f):
    for i in range(len(l)):
        l[i] = f(l[i])
    return l

def tronc(l):
    if l[len(l)-1] == "\n":
        l = l[0:len(l)-1]
    return l

def ajout(x,y,l):
    lis = separer(l)
    print(lis)
    x = x + [lis[0]]
    y = y + [lis[1]]
    return(x,y)
    
def instances(nom_fichier_lu , nom_fichier_cree , n):
    fichier_lu = open(nom_fichier_lu , "r")
    lines = fichier_lu.readlines()
    try:
        fichier_cree = open(nom_fichier_cree , "x")
        
    except:
        fichier_cree = open(nom_fichier_cree , "w")
        
    fichier_cree.write("param n := " + tronc(lines[0]) + ";\n")
    fichier_cree.write("param i_d := " + tronc(lines[1]) + ";\n")
    fichier_cree.write("param i_a := " + tronc(lines[2]) + ";\n")
    fichier_cree.write("param A_min := " + tronc(lines[3]) + ";\n")
    fichier_cree.write("param m := " + tronc(lines[4]) + ";\n")
    fichier_cree.write("param Z := ")
    z_line = lines[6]
    z_list = separer(z_line)
    for i in range(n-1):
        fichier_cree.write(str(i+1) + " " + z_list[i] + "\n")
    fichier_cree.write(str(n) + " " + tronc(z_list[n-1]) + ";\n")
    fichier_cree.write("param R := " + tronc(lines[8]) + ";\n")
    x = []
    y = []
    for i in range(n):
        l = lines[i+10]
        x,y = ajout(x,y,l)
    fichier_cree.write("param X:= ")
    print(len(x))
    for i in range(n-1):
        fichier_cree.write(str(i+1) + " " + str(int(x[i])) + "\n")
    fichier_cree.write(str(n) + " " + str(int(x[n-1])) + ";\n")
    fichier_cree.write("param Y:= ")
    for i in range(n-1):
        fichier_cree.write(str(i+1) + " " + str(int(y[i])) + "\n")
    fichier_cree.write(str(n) + " " + str(int(y[n-1])) + ";\n\n")
    fichier_cree.write("let {i in 1..n, j in 1..n} D[i,j]:=round(sqrt((X[i]-X[j])**2+(Y[i]-Y[j])**2));")
    return 0
