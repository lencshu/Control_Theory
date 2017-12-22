%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   TD06     %clear all;clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    parmaètres du moteur DC     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
r=2;            % Résistance d induit S.I
k=0.1;          % constante de vitesse et de couple du moteur SI
f=0.2;          % frottement visqueux
j=0.02;         % Inertie de l arbre moteur
l=0.5; 			%inductance de l induit

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Fonction de tranfert  continue '@Q2.1' %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
T0=k/(r*f+k*k);		%gain statique
w0=sqrt((f*r+k*k)/(l*j));	%pulsation naturelle, boucle ouvert
TauxBO=1/w0;

%m=(R*J+L*f)/(2*sqrt((k^(2)+R*f)*L*J));
m1=(l*f+r*j)/(r*f+k*k)*(w0/2);	%damping ratio, taux d amortissement, 

frequence=w0/(2*pi);	%fréquence naturelle,w=2*pi*fréquence

num0=[T0];
den0=[1/(w0*w0) 2*m1/w0 1];
Tm=tf(num0,den0,'variable','p');    % Tm fonction de transfert continue

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Fontion de transfert discrétisée sans correcteur  '@Q3'  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Te=0.01;	%Periode d'échantillonnage d'après CdC

Tmd=c2d(Tm,Te)     % Tmd fonction de transfert discrétisée
Tauxp = stepinfo(Tmd,'RiseTimeLimits',[0,0.63])       %la constante de temps Tp du système sans correcteur en boucle ouvert @3.1
zpk(Tmd,'v')    %Pour voir ou sont les poles ( 'v') est la car c'est une output

	b1=0.0004773;	%coefficient numérateur de T0d
	b2=0.0004555;

	a1=-1.866   %coefficient denominateur de T0d
	a2=0.8694

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Fontion de transfert discrétisée avec correcteur P '@Q4.1'  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%pour trouver valeur l'encadrement de K (0<K<intersection entre ligne bleue et cercle)
rlocus(Tmd);
axis('equal');grid;

%on choisit la valeur de K
K=12; 
Tmd_B0p=series(K,Tmd);		%connecter avec un correcteur proportionnel en serie 
Tmd_BFp=feedback(Tmd_B0p,1);	%connection en boucle fermé

%step(Tmd_BFp);		%afficher le step graphe

Steady_timeP=stepinfo(Tmd_BFp,'SettlingTimeThreshold',0.05);		%le temps qu il faut le système soit stable

rlocus(Tmd_BFp);		%root locus, lieux d Evans '@Q4.1.2'
axis('equal');grid;		%readable
%[k,poles]=rlocfind(Tmd_BFp);	%trouver la valeur du point
%sisotool(Tmd_BFp);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Fontion de transfert discrétisée avec correcteur PID filtré '@Q4.1'  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
w1=4*w0;	%pulsation de BF d après CdC
m2=0.707;	%damping ratio, taux d amortissement, overshoot
sgrid(m2,frequence);

num1=[1];
den1=[(1/w1)^2 (2*m2)/w1 1];
T1=tf(num1,den1,'variable','p');
T1d=c2d(T1,Te);	%Determination T1d(z)

	%On recupere les coefficients de T1d
	p1=-1.641;
	p2=0.6962;

	%On définit les coefficients du correcteur
	r0pid=(1+p1+p2)/(b1+b2);
	r1pid=a1*r0pid;
	r2pid=a2*r0pid;
	s1=r0pid*b2-p2;

%Fonction de transfert du correcteur PID filtré
numPID=[r0pid r1pid r2pid]
denPID=[1 -1+s1 -s1]
Kpid=tf(numPID,denPID,Te,'variable','z')

%Fonction de transfert en BF ac correcteur PI
Tmd_BOpid=series(Kpid,Tmd)
Tmd_BFpid=feedback(Tmd_BOpid,1)

step(T1,T1d,Tmd_BFpid)
Steady_timePID=stepinfo(Tmd_BFpid,'SettlingTimeThreshold',0.05)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Fontion de transfert discrétisée avec Correcteur pile '@Q5.1'  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
num2=[1];
den2=[1 0];
Gamma_statique=tf(num2,den2,Te,'variable','z');

Ks=(Gamma_statique)/(Tmd*(1-Gamma_statique));	%FT de statique
                                      
T_statique_pile_bo=series(Ks,Tmd);
T_statique_pile_bf=feedback(T_statique_pile_bo,1);
step(T_statique_pile_bf,T1d,Tmd_BFpid);
Steady_timestatique=stepinfo(T_statique_pile_bf,'SettlingTimeThreshold',0.05);

%Erreur vitesse nulle
num3=[2 -1];
den3=[1 0 0];
Gamma_trainage=tf(num3,den3,Te,'variable','z');
Kt=(Gamma_trainage)/(Tmd*(1-Gamma_trainage)); %FT de traînage

%simulink pour mettre une rampe en entrée