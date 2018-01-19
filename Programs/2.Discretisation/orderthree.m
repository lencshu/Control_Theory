clear all;
clc;

r=2;        % Résistance d induit S.I
k=0.1;      % constante de vitesse et de couple du moteur SI
f=0.2;      % frottement visqueux
j=0.02;     % Inertie de l arbre moteur
l=0.5;      % inductance de l induit (que nous négligerons)

Te=20e-3;           % pédiode d échantillonnag d après CdCh
TauxBO=(r*j)/(r*f+k^2);         % constante de temps du système

k0=k/(r*f+k^2);                 % gain statique
w0=1/TauxBO;                    % pulsation naturelle, boucle ouvert
frequence=w0/(2*pi);            % fréquence naturelle,w=2*pi*fréquence

num0=[k0];
den0=[TauxBO 1];
Tm=tf(num0,den0,'variable','p')    % Tm fonction de transfert continue
Tmd=c2d(Tm,Te)      % Tmd fonction de transfert discrétisée

%la constante de temps du système sans correcteur en boucle ouvert
Tauxp = stepinfo(Tmd,'RiseTimeLimits',[0,0.63])

zpk(Tmd,'v')            % Pour voir ou sont les poles ( 'v') est la car c est une output
b1=Tmd.num{1}(2);               % coefficient numérateur de Tmd
a1=Tmd.den{1}(2);               % coefficient dénonominateur de Tmd

%{
%%%%% PID
%给定的条件
%Determination FT discrétisée d apres Cdc
w1=1/TauxBO
m=0.707; %damping ratio, taux d amortissement, overshoot

num3=[1]; % gain statique
den3=[(1/w1)^2 (2*m)/w1 1]

%Fonction de transfert en BF discrétisée
T2=tf(num3,den3,'variable','p');
T2d=c2d(T2,Te)

% Fonction de transfert en BF discrétisée Ordre 3
Td=tf(1,[1 -0.001],Te)
T3d=T2d*Td  % Fonction de transfert d'ordre 3

[P2d]=T3d.den{1} % Tableau contenant les coefficients du dénominateur
p1=P2d(2)
p2=P2d(3)
p3=P2d(4)

%Calcul des coefficients du correcteur PID  
r0pid=(1-a1+p1)/b1       
r1pid=(p2+a1)/b1
r2pid=p3/b1

%Fonction transfert du correcteur PID
numPID=[r0pid r1pid r2pid];
denPID=[1 -1 0];
Kpid=tf(numPID,denPID,Te,'variable','z')

%Fonction transfert en BO Correcteur + Processus
Tm_BOpid=Kpid*Tmd;   % fonction de transfert en B0

%Fonction transfert en BF Correcteur + Processus
Tm_BFpid=feedback(Tm_BOpid,1);   % fonction de transfert en B0

% step(T2,T2d,T3d,Tm_BFpid)   % réponse à un échelon
% legend('T2','T2d','T3d','Tm_BFpid')

NPID=Kpid.num{1} % numérateur Kpid
DPID=Kpid.den{1} % dénominateur Kpid


%}