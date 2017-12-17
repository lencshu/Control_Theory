%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Asservissement DC Moteur     %
%              en vitesse          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         Paramètre du moteur DC   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

R=2; % Résistance
k=0.1; % Constantes Moteur
f=0.2; % Frottement
J=0.02; % Inertie ramenée sur l'arbre moteur

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         Fonction de transfert    %
%               continue           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Taux0=(R*J)/(R*f+k^2); % Constante de temps du système
k0=k/(R*f+k^2); % Gain statique
w0=1/Taux0; % Pulsation naturelle

num0=[k0];
den0=[Taux0 1];
T0=tf(num0,den0,'variable','p') % Fonction de transfert continue

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fonction de transfert discrétisée%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Te=50e-3; % Période d'échantillonage d'après cahier des chagres
T0d=c2d(T0,Te)
zpk(T0d,'v');% Zéro, pole Gain -> zpk -> permet de mettre la fonction de transfert sous cette forme
b1=0.09781 % Coefficient numérateur de T0d
a1=-0.599 % Coefficient dénominateur de T0d
%rlocus(T0d);

K=12; 
T0_B0=series(K,T0d)
T0_BF=feedback(T0_B0,1)
%step(T0_BF)
data=stepinfo(T0_BF,'SettlingTimeThreshold',0.05)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         Cahier des charges        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% erreur statique nulle 
% constante  de temps divisé par 4

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Fonction de transfert en BF     %
%            continue T1            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Correcteur PI

Taux1=24.4e-3;
K1=k0;
num1=(K1);
den1=[Taux1 1];
T1=tf(num1,den1)

T1d=c2d(T1,Te) %Discrétise une fonction continue
B1=1-exp(-Te/Taux1); %(1-alpha)

r0pi=B1/b1;
r1pi=r0pi*a1;

numPI=[r0pi r1pi];
denPI=[1 -1];
Kpi=tf(numPI,denPI,Te,'variable','z')
TpiBO=series(Kpi,T0d)
Tpibf=feedback(TpiBO,1)
%step(T1,T1d,Tpibf)

%%%%%%%%%%%%%%%%%%%%%%
%   Correcteur PID   %
%%%%%%%%%%%%%%%%%%%%%%

m=0.707;
w1=1/Taux0;
K2=k0;
num2=(K2);
den2=[1/w1^2 2*m/w1 1];
T2=tf(num2,den2)

T2d=c2d(T2,Te)
num3=[1 0];
den3=[1 0.001];
Temp=tf(num3,den3);
Tempd=c2d(Temp,Te)
T3d=T2d*Tempd

p1PID=1.786;
p2PID=-2.302;
p3PID=1;

r0PID=(1-a1+p1PID)/b1;
r1PID=(p2PID+a1)/b1;
r2PID=p3PID/b1;

num4=[r2PID r1PID r0PID];
den4=[-1 1];
kPID=tf(num4, den4);
kPIDd=c2d(kPID,Te);
% Kpid=tf(num4,den4,Te,'variable','z')