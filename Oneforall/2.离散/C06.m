clc;
clear;

%{
- 目的: 设计un correcteur polynômiale
- 要求 cahier des charges:
	+ dynamique fixée par un second ordre : 
		* `w1=1.4 rad/s`  
		* `m=0.8`
	+ Ep: erreur de position nulle - `réponse à un échelon`
	+ Ev: erreur de vitesse nulle - `réponsde à une rampe`
- 初始条件:
	+ Le processus analogique a pour caractéristiques:
		* `w0=0.8 rad/s`
		* `m=0.1`
		* gain statique `T0=1`
	+ Période échantillonnage `Te=0.72`
%}


%%%% Le processus analogique TFBO
Te=0.72; % Période échantillonnage
w0=0.8; % pulsation propre du processus en BO
m=0.1;   % coefficient d'amortissement
T0=1;   % gain statique

num0=[T0];
den0=[1/w0^2 2*m/w0 1];
F0=tf(num0,den0)    % F0(p)
F0d=c2d(F0,Te)      % discrétisation de la fonction de transfert en BO

% T0d=zpk(F0d);
% [z0d,p0d,k0]=zpkdata(T0d)

%%%% FTBF fixé par le cahier des charges
w1=1.4 ; % pulsation propre du processus en BF
m1=0.8;  % coefficient d'amortissement
num1=[1];
den1=[1/w1^2 2*m1/w1 1];
F1=tf(num1,den1)
F1d=c2d(F1,Te) % Discrétisation de la fonction de transfert en BF 
% [z1d,p1d,T1d]=zpkdata(F1d) % liste zéro - pôle - gain

[D1d]=F1d.den{1} % D1d=z^2+D1d(2)*z+D1d(3)

%%%% Coefs du correcteur
ev=0.5; % erreur de vitesse en régime permanent
DBF1=sum(D1d) % =DBF(1)
%% Résolution du système linéaire 
% 不存在积分器
A=[0 0 1 0;1 0 -1 1;0 1 0 -1;0 0 1 1]
% 存在一个积分器
% A=[1 0 1 0;0 1 -1 1;0 0 0 -1; 0 0 1 1];
B=[1;D1d(2);D1d(3);ev*DBF1/Te]
Sol=A\B % Solution du système
theta0=Sol(1);
theta1=Sol(2);
pI0=Sol(3);
pI1=Sol(4);
theta=[theta0 theta1]; %polynôme theta(z)=theta0*z+theta1
pI=[pI0 pI1]; %polunôme pI(z)=pI0*z+pI1

%%%% Réalisation du correcteur
%%% K(z)=[Dstable(z)Sm(z)Theta(z)]/[Nstable(z)Sr(z)Pi(z)] D和N交换位置
Ds=F0d.den{1} ;
%获取的系数需要再Z转换
Dstable=tf(Ds,1,Te)
Sm=1;	% pas d'integrateur
Theta=tf(theta,1,Te)

[z0,k0]=zero(F0d); %return zero point of sys F0d
Ns=k0*[1 -z0]; 
Nstable=tf(1,Ns,Te)% 1/N+(z)
Sr=[1 -1]; % un integrateur
tfSr=tf(1,Sr,Te)	% Sr(z)
Pi=tf(1,pI,Te) % 1/pI(z)

K=Dstable*Theta*Nstable*tfSr*Pi

%%%% Extraction simulink
NK=K.num{1}
DK=K.den{1}

NP=F0d.num{1}
DP=F0d.den{1}