%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Asservissement DC Moteur     %
%      en vitesse                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Fichier TDC1A2017            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% commande octave                 %
 % pkg load control

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    parmaètres du moteur DC     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
R=2;            % Résistance d'induit S.I
L=0.5;           % Inductance de l'induit S.I
k=0.1;          % constante de vitesse et de couple du moteur SI
f=0.2;          % frottement visqueux
J=0.02;         % Inertie de l'arbre moteur

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Fonction de tranfert        %
%       continue                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
T0=k/(R*f+k^2);              % gain statique
w0=sqrt((R*f+k^2)/(L*J));    %pulsation propre
m0=0.5*(R*J+L*f)/sqrt((L*J)*(R*f+k^2));   % coefficient d'amortissement


num0=[T0];
den0=[1/w0^2 2*m0/w0 1];
T0=tf(num0,den0,'variable','p') % T0 fonction de transfert continue

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Fontion de transfert discrétisée%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Te=10e-3;               % pédiode d'échantillonnag d'après CdCh
T0d=c2d(T0,Te)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   T0d est de la forme                              %
%  T0d=[b1*z^-1+b2*z^-2]/[1+a1*z^-1+a2*z^-2]         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

NBO=T0d.num{1}
b1=NBO(2)
b2=NBO(3)
DBO=T0d.den{1}
a1=DBO(2)
a2=DBO(3)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       cahier des charges       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% erreur de postion nulle       %
% pulsation propre w1=4*w0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Fonction de transfert en BF  %
%       continue T1              %
%          Ordre2                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

w1=4*w0;
m1=0.707;
num1=[1];
den1=[1/w1^2 2*m1/w1 1];
T1=tf(num1,den1,'variable','p') % T1 fonction de transfert continue

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Fonction de transfert en BF  %
%       discrétisée T1d          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
T1d=c2d(T1,Te)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%  T1d est de la forme                               %
%    T1d=[NT1d(z)]/[1+p1*z^(-1)+p2*z^(-2)]              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
DBF=T1d.den{1}
p1=DBF(2)  % coefficient de DBF
p2=DBF(3)  % coefficient de DBF


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     Réalisation du correceteur                    %%%
%%% K(z)=[r0+r1*z^-1+r2*z^-2]/[(1-z^-1)*(1+s1*z^-1)]  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
r0=(1+p1+p2)/(b1+b2)
r1=a1*r0
r2=a2*r0
s1=r0*b2-p2

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% calcul de la fonction de transfert K(z)          %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
numK=[r0 r1 r2]
denK=[1 s1-1 -s1]
K=tf(numK,denK,Te)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%       Extraction Simulink                       %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NPID=K.num{1}
DPID=K.den{1}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Mise en place d'un correceteur polynomial      %%%
%%%     1er cas erreur de position nulle            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%     Détermination N+,N-,D+,D-,Sm                %%%

[Z0d,P0d,k0]=zpkdata(T0d)
Z0=zero(T0d)
Ns=tf(k0*[1 -Z0],1,Te)       % N+(z)
Ds=tf(T0d.den{1},1,Te)       %D+(z)
Sm=1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Résolution de l'eq diophantienne               %%%%
%%%%  Détermination de O(z) et PI(z)                %%%%
%%%% O(z)=o0+o1*^-1   et PI(z)=pi0                  %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pi0=1
o0=p1+pi0
o1=p2

%%%% Réalisation du correceur Kp(z)                 %%%%
Sr=[1 -1 0] % =(1-z^-1)*z^-2
TSr=tf(1,Sr,Te)
Ttheta=tf([o0 o1],1,Te)
Kp=Ds*Sm*Ttheta*TSr*1/Ns

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%       Extraction Simulink                       %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

NKp=Kp.num{1}
DKp=Kp.den{1}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Mise en place d'un correceteur polynomial      %%%
%%%     2ème  cas erreur de vitesse nulle           %%%
%%%  il faut deux intégrateurs                      %%%
%%% Sr1=(1-z^-1)^2                                  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Résolution de l'eq diophantienne               %%%%
%%%%  Détermination de O1(z) et PI1(z)              %%%%
%%%% O1(z)=o10+o11*^-1   et PI(z)=pi10              %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pi10=1
o10=p1+2*pi10
o11=p2-pi10

%%%% Réalisation du correceur Kp1(z) 

Ttheta1=tf([o10 o11],1,Te)
Sr1=[1 -2 1]        % Annule l'erreur de vitesse- deux intégrateurs
TSr1=tf(1,Sr1,Te)   % fonction de transfert de Sr1
Kp1=Ds*Sm*Ttheta1*TSr1*1/Ns

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%       Extraction Simulink                       %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

NKp1=Kp1.num{1}
DKp1=Kp1.den{1}

NP=T0d.num{1}
DP=T0d.den{1}






