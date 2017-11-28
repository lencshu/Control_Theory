clc;
clear;
%Inverse Z-Transform
syms z;
F=10*z/((z-1)*(z-2));
iztrans(F);

%Decomposition en element simple
num=[1 0];
den=[1 -1 2]; %[1 -3 2]; %conv([1 -1/3],[1 -3]);
[r,p,k]=residue(num,den)
R=rat(r);


%{
tf
c2d()
residue
step
imp
zpk
%}