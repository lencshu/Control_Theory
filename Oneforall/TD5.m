%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   TD05     % clear all;clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    parmaètres du moteur DC     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
r=2;            % Résistance d induit S.I
k=0.1;          % constante de vitesse et de couple du moteur SI
f=0.2;          % frottement visqueux
j=0.02;         % Inertie de l arbre moteur

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Fonction de tranfert   continue '@Q2.1' %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
TauxBO=(r*j)/(r*f+k^2);       %constante de temps du système
T0=k/(r*f+k^2);              %gain statique
w0=1/TauxBO;                  %pulsation naturelle, boucle ouvert
frequence=w0/(2*pi);	%fréquence naturelle,w=2*pi*fréquence

num0=[T0];
den0=[TauxBO 1];
Tm=tf(num0,den0,'variable','p')    % Tm fonction de transfert continue

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Fontion de transfert discrétisée sans correcteur  '@Q3'  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Te=10e-3;               % pédiode d échantillonnag d après CdCh
Tmd=c2d(Tm,Te)     % Tmd fonction de transfert discrétisée

	%%%%%%%%%%%%%%%%%%
	%@Q3.2
zpk(Tmd,'v')             %Pour voir ou sont les poles ( 'v') est la car c'est une output
b1=0.023761             % coefficient numérateur de Tmd
a1=-0.9026              % coefficient dénonominateur de Tmd
	%%%%%%%%%%%%%%%%

%Tauxp = stepinfo(Tmd,'RiseTimeLimits',[0,0.63])       %la constante de temps du système sans correcteur en boucle ouvert @3.1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Fontion de transfert discrétisée avec correcteur proportionnel '@Q4.1'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%pour trouver valeur l'encadrement de K (0<K<intersection entre ligne bleue et cercle)
%	rlocus(Tmd);
%	zgrid;

%on choisit la valeur de K
K=12; 


Tmd_BOp=series(K,Tmd);	%Fct de transfert BO ac gain proportionnel

Tmd_BFp=feedback(Tmd_BOp,1);	%connection en boucle fermé

%step(Tmd_BFp);		%afficher le step graphe

%Steady_timeP=stepinfo(Tmd_BFp,'SettlingTimeThreshold',0.05);		%le temps qu il faut le système soit stable

%	rlocus(Tmd_BFp);		%root locus, lieux d Evans '@Q4.1.2'
%	axis('equal');grid;		%readable
%[k,poles]=rlocfind(Tmd_BFp);	%trouver la valeur du point
%sisotool(Tmd_BFp);

%	Zeta = 0.7;			%damping ratio, taux d amortissement, overshoot
%	sgrid(Zeta,frequence);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Fontion de transfert discrétisée avec correcteur PI '@Q4.2'  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%etap 1: Fonction de transfert en BF continue T1 d'apres CdC @4.2.1
w1=4*w0;
num1=[1];
den1=[1/w1 1];
T1=tf(num1,den1,'variable','p');

T1d=c2d(T1,Te);	%Fonction de transfert discretisée
%hold on
%step(Tmd_BFp);

B1=0.3363;	% le gain statique du système désiré

%étape 2: Calcul des coeficients du correcteur PI @4.2.2
r0pi=B1/b1;
r1pi=r0pi*a1; 

numPI=[r0pi r1pi];
denPI=[1 -1];
Kpi=tf(numPI,denPI,Te,'variable','z');	%Fonction de transfert du correcteur PI

%étape 3: Fonction de transfert en BF avec un correcteur PI
Tmd_BOpi=series(Kpi,Tmd);	%Fct de transfert BO ac gain PI
Tmd_BFpi=feedback(Tmd_BOpi,1);

%step(T1,T1d,Tmd_BFpi);
%Steady_timePI=stepinfo(Tmd_BFpi,'SettlingTimeThreshold',0.05)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Fontion de transfert discrétisée avec correcteur PID '@Q4.3'  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Determination FTD d'apres Cdc
m=0.707;
num3=[1];
den3=[(1/w1)^2 (2*m)/w1 1]
T2=tf(num3,den3,'variable','p');

Tauxpid=Te/4;
num4=[1];
den4=[Tauxpid 1]
T3=tf(num4,den4,'variable','p');
T4=series(T2,T3);
T4d=c2d(T4,Te);

	%On recupere les coefficients de T4d
%{p1=- 2.223;
p2=1.548;
p3=- 0.3182; %}

p1=-1.453
p2=0.5863
p3=-0.01026
	%On définit les coefficients du correcteur
r0pid=(1-a1+p1)/b1;
r1pid=(p2+a1)/b1;
r2pid=p3/b1;

%Fonction de transfert du correcteur PID filtré
numPID=[r0pid r1pid r2pid];
denPID=[1 -1 0];
Kpid=tf(numPID,denPID,Te,'variable','z');

%Fonction de transfert en BF ac correcteur PID
Tmd_BOpid=series(Kpid,Tmd);
Tmd_BFpid=feedback(Tmd_BOpid,1);

step(T4,T4d,Tmd_BFpid);
Steady_timePID=stepinfo(Tmd_BFpid,'SettlingTimeThreshold',0.05);