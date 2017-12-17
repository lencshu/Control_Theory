%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Asservissement DC Moteur     %
%      en vitesse                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;
clear;
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
Te=20e-3;               % pédiode d'échantillonnag d'après CdCh
T0d=c2d(T0,Te)
zpk(T0d,'v')
b1=0.04521             % coefficient numérateur de Tod
a1=-0.8146             % coefficient dénonominateur de Tod
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
numl = [1];
den1=[Taux1 1];
T1=tf(numl,den1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Fonction de transfert en BF  %
%       discrétisée T1d          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
T1d=c2d(T1,Te)
B1=0.5596;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Calcul des coefficients      %
%      du correcteur PI          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
r0pi=B1/b1;         
r1pi=r0pi*a1;

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Fonction transfert           %
%      du correcteur PI          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
numPI=[r0pi r1pi];
denPI=[1 -1];
Kpi=tf(numPI,denPI,Te,'variable','z')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Fonction transfert           %
%  en BF avec un correcteur PI   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
TpiBO=series(Kpi,T0d)
Tpibf=feedback(TpiBO,1)



 step(T1,T1d,Tpibf) %%%
