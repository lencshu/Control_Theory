clc;
clear;

%{

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

%}

%{
s=tf('s');
g=1/(s+1);
ts=0.1;
r=1/s;
%step(R-G*R);

%control function
c=(500*s+50)/(100*s^2+s);
cl=feedback(c*g,1);
%step(1/s-cl/s);
%bode(c*g);

%zoh采样方法
cz=c2d(g,ts,'zoh')
bode(c,cz);
%}

syms z;
num=conv([1 -1],conv([1 -1],[1 -0.3]))

den1=conv([1 -1],conv([1 -1],conv([1 -1],[1 -0.3])))
