clc
clear

%{
传递函数初始化
1.已知多项式
den=conv([1 0 0],conv([1 3],[1,2,3,4]));

2.已知zpk
z=[0];p=[1,3,5];k=6;
sys=zpk(z,p,k);
[num,den]=zp2tf(z,p,k);
[A,B,C,D]=zp2ss(z,p,k);

3.C=eye(3)
[V,D]= eig(A-B*K)返回矩阵的特征值和特征向量(根)
%}

%====赋值操作初始化====
k=1;
m=1;

%====初始化矩阵====

A11=0;
A12=1;
%A13=;
%A14=;

A21=-k/m;
A22=0;
%A23=;
%A24=;
%{
A31=;
A32=;
A33=;
A34=;

A41=;
A42=;
A43=;
A44=;
%}
B=[0;1/m];


%A11=0;  A12=1;  A13=0;  A14=0;  A21=-k/jc;  A22=-lamc/jc;  A23=k/jc;  A24=0;  A31=0;  A32=0;  A33=0;  A34=1;  A41=k/jm;  A42=0;  A43=-k/jm;  A44=-lamm/jm;

%A=[A11 A12 A13 A14; A21 A22 A23 A24; A31 A32 A33 A34; A41 A42 A43 A44];
A=[A11 A12 ; A21 A22];
%B=[0;0;0;1/jm];
C=[1 0]; %[1 0 0 0];
D=[0];
sys=ss(A,B,C,D);
[zero,pole,k_gain]=zpkdata(sys,'v'); %'v'返回多项式系数向量


%{
====可控与可观====
rang(Co/Ob) soit n,Le parametre n etant le nombre de variables d'etat dans le vecteur d'etat X 
%}
Co=ctrb(sys); 
Rco= rank(Co);
Ob=obsv(sys);
Rob=rank(Ob);
%判断
n=size(A,1); %返回向量的行数
if Rco==n 
    display('systeme controlable') 
    else; 
    display('systeme non controlable') 
end
if Rob==n 
    display('systeme observable') 
    else; 
    display('systeme non observable') 
end

%{
====pole dominant====
此时一般就要求性能指标==>simulink模拟
Temps de reponse a 5%(Tr5%)==> setting time
Temps de montee (Tm10-90)==> rise time
Peak reponse de depassement ==>	peak ampititude, overshot,at time
Erreur de position ==> difference de final value
Coef amortissement ==> damping raito
pulsation propre ω(rad/s) ==> natural frequence f*2π
%}

kesi=0.5;     %Coef d'amortissement
tr=0.5;        % temps de reponse ==>setting time
omega0mini=3/(kesi*tr);  
p1=-kesi*omega0mini+1i*omega0mini*sqrt(1-kesi^2);
p2=-kesi*omega0mini-1i*omega0mini*sqrt(1-kesi^2);

%dans un rapport 10 avec les valeurs reel pole dominant
P=[p1; p2; 10*real(p1); 10*real(p2)+0.01];
%La matrice de contre reaction K 
K=place(A,B,P);


%dans un rapport 5 pour pole d'observateur
Pob=[p1; p2; 5*real(p1); 5*real(p2)+0.01];
Kob=place(A,B,Pob);
L=place(A.',C.',Pob).';


%{
======LQR======
pour optimiser la matrice de gain
替换simulink中的Kopt
%}
trsi=0.5;  %desired settle time (tr5%)
x1m=pi;
x2m=100;
x3m=10;
x4m=100;

Q11=1/(trsi*x1m^2);
Q22=1/(trsi*x2m^2);
Q33=1/(trsi*x3m^2);
Q44=1/(trsi*x4m^2);
Q=[Q11 0 0 0;0 Q22 0 0;0 0 Q33 0; 0 0 0 Q44];

u=0.5;
r1=1/u^2;
rho=1;
%rho=0.6; %要求高性能
R=rho*r1;
[Kopt,Popt,E]=lqr(A,B,Q,R);


%{
======卡尔曼滤波器======
M，W，V的值
把L的值替换为Kf
%}

M=[0.1 0 0 0; 0 0.1 0 0; 0 0 0.00132 0 ;0 0 0 0.1];
W=[0.1 0 0 0;0 0.1 0 0;0 0 0.1 0;0 0 0 0.1];
V=[0.1 0 0 0;0 0.01 0 0; 0 0 7.46 0;0 0 0 0.01];

[Kf,P,E]=lqe(A,M,C,W,V);
