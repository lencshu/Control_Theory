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

%{
%TD4 -Ex1
Te=0.01; %periode echantillonage

% T0 function de transfert continue de process
T0s=1; %gain statique
Taux=1; %constate de process
num0=[T0s];
den0=[Taux 1];
T0=tf(num0,den0,'variable','p');

% T0d function de transfert discretisee z[Bo(p)T(p)]
T0d=c2d(T0,Te);
%rlocus(T0d);

% fonction en boucle ouvert FTBO(z)=K*T0d(z)     avecK=3
k=3;
FTBO=k*T0d;

% fonction en boucle ferme FTBF(z)
FTBF=feedback(FTBO,1);

% reponse a un echelon unitaire
step(FTBF)

%}

%{
%TD4 -Ex2

Te=2; %periode echantillonage

% T0 function de transfert continue de process
Taux1=10; %constate de process
Taux2=2; %constate de process
num1=[1];
den1=[Taux1 1];
T1=tf(num1,den1,'variable','p');
num2=[1];
den2=[Taux1 1];
T2=tf(num2,den2,'variable','p');
T3=T1*T2;
T3d=c2d(T3,Te);
rlocus(T3d);
%}