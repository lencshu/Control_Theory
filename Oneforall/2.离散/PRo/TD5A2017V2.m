clc;
clear;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Asservissement DC Moteur     %
%      en vitesse                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    parmaètres du moteur DC     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
R=2;            % Résistance d'induit S.I
k=0.1;          % constante de vitesse et de couple du moteur SI
f=0.2;          % frottement visqueux
J=0.02;         % Inertie de l'arbre moteur

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Fonction de tranfert        %
%       continue                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Taux0=(R*J)/(R*f+k^2);       %constante de temps du système
k0=k/(R*f+k^2);              %gain statique
w0=1/Taux0;                  %pulsation naturelle

num0=[k0];
den0=[Taux0 1];
T0=tf(num0,den0,'variable','p') % T0 fonction de transfert continue

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Fontion de transfert discrétisée%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Te=50e-3;               % pédiode d'échantillonnag d'après CdCh
T0d=c2d(T0,Te)
zpk(T0d,'v')
%%% Tod=b1 z/(z+a1)=b1*z^-1/(1+a1*z^-1)
b1=T0d.num{1}(2);              % coefficient numérateur de Tod
a1=T0d.den{1}(2);         % coefficient dénonominateur de Tod
rlocus(T0d);
K=12; 
T0_B0=series(K,T0d)
T0_BF=feedback(T0_B0,1)
step(T0_BF)
data=stepinfo(T0_BF,'SettlingTimeThreshold',0.05)
step(T0_BF)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       cahier des charges       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% erreur position nulle
% constante de temps de 24.4 ms
% gain unitaire

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Fonction de transfert en BF  %
%       continue T1              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Taux1=24.4e-3 ; % constante de temps en BF
k1=1;  % gain statique
num1=[k1];
den1=[Taux1 1];
T1=tf(num1,den1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Fonction de transfert en BF  %
%       discrétisée T1d          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
T1d=c2d(T1,Te)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%    T1d de la forme          %%%    
%%%   T1d=B1*z^-1/(1+A1*z^-1)   %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
B1=T1d.num{1}(2) 
A1=T1d.den{1}(2)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Calcul des coefficients      %
%      du correcteur PI          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
r0pi=B1/b1;         
r1pi=r0pi*a1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Fonction transfert           %
%      du correcteur PI          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
numPI=[r0pi r1pi];
denPI=[1 -1];
Kpi=tf(numPI,denPI,Te,'variable','z')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Fonction transfert           %
%  en BO Correcteur + Processus  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FTBO=Kpi*T0d

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Fonction transfert           %
%  en BF avec un correcteur PI   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
Tpibf=feedback(FTBO,1) % fonction de transfert en BF

 Steady_timePI=stepinfo(Tpibf,'SettlingTimeThreshold',0.05)
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Fonction de transfert en BF  %
%       continue T2              %
%   w2=1/Taux0 - m=0.707         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Taux2=24.4e-3 ; % constante de temps en BF
k2=1;       % gain statique
m2=0.707;   % coefficient d'amortissement
w2=1/(Taux0); % pulsation propre du système
num2=[k2];
den2=[1/w2^2 2*m2/w2 1];
T2=tf(num2,den2)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Fonction de transfert en BF  %
%       discrétisée T2d          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
T2d=c2d(T2,Te)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Fonction de transfert en BF  %
%       discrétisée T3d          %
%       Ordre 3                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Td=tf(1,[1 -0.001],Te)
T3d=T2d*Td  % Fonction de transfert d'ordre 3

[P2d]=T3d.den{1} % Tableau contenant les coefficients du dénominateur
p1=P2d(2)
p2=P2d(3)
p3=P2d(4)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Calcul des coefficients      %
%      du correcteur PID         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
r0pid=(1-a1+p1)/b1       
r1pid=(p2+a1)/b1
r2pid=p3/b1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Fonction transfert           %
%      du correcteur PID          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
numPID=[r0pid r1pid r2pid];
denPID=[1 -1 0];
Kpid=tf(numPID,denPID,Te,'variable','z')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Fonction transfert           %
%  en BO Correcteur + Processus  %
%       Kpid*T0d
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FTBO1=Kpid*T0d   % fonction de transfert en B0




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Fonction transfert           %
%  en BF avec un correcteur PID  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
Tpidbf=feedback(FTBO1,1) % fonction de transfert en BF

step(T1,T1d,Tpibf,T2,T2d,T3d,Tpidbf)   % réponse à un échelon
legend('T1','T1d','Tpibf','T2','T2d','T3d','Tpidbf') 

%%% Extraction simulink


NPID=Kpid.num{1} % numérateur Kpid
DPID=Kpid.den{1} % dénominateur Kpid

NP=T0d.num{1}    % numérateur du système en BO
DP=T0d.den{1}     % dénominateur du sytème en B0




 

