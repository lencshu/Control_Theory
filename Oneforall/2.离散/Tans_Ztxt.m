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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   TD05     % clear all;clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 	1	parmaètres du moteur DC     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
r=2;            % Résistance d induit S.I
k=0.1;          % constante de vitesse et de couple du moteur SI
f=0.2;          % frottement visqueux
j=0.02;         % Inertie de l arbre moteur
l=0.5;			% inductance de l induit (que nous négligerons)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 	2	Fonction de tranfert continue
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

TauxBO=(r*j)/(r*f+k^2);			% constante de temps du système
t0=k/(r*f+k^2);					% gain statique 
w0=1/TauxBO;					% pulsation naturelle, boucle ouvert
frequence=w0/(2*pi);			% fréquence naturelle,w=2*pi*fréquence

num0=[t0];
den0=[TauxBO 1];
Tm=tf(num0,den0,'variable','p')    % Tm fonction de transfert continue


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	3	Fontion de transfert discrétisée sans correcteur
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%	3.1 
%Justifier le choix de la période d échantillonnage
Te=20e-3;			% pédiode d échantillonnag d après CdCh
Tmd=c2d(Tm,Te)		% Tmd fonction de transfert discrétisée

%la constante de temps du système sans correcteur en boucle ouvert
Tauxp = stepinfo(Tmd,'RiseTimeLimits',[0,0.63])

%%%%%%%%%%%	3.2 
%Établir la fonction de transfert du moteur

zpk(Tmd,'v')			% Pour voir ou sont les poles ( 'v') est la car c est une output
b1=0.045208				% coefficient numérateur de Tmd
a1=-0.8146				% coefficient dénonominateur de Tmd


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	4.1	Fontion de transfert discrétisée avec correcteur proportionnel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%4.1.1 
%Étudier la stabilité du correcteur proportionnel en fonction de son gain K
%pour trouver valeur l encadrement de K (0<K<intersection entre ligne bleue et cercle)

%%sisotool(Tmd); % plus puissant
%rlocus(Tmd);
%zgrid;

%on choisit la valeur de K
K=12; 

%Fct de transfert BO ac gain proportionnel
Tmd_BOp=series(K,Tmd);	

%connection en boucle fermé
Tmd_BFp=feedback(Tmd_BOp,1);	
%step(Tmd_BFp);		%afficher le step graphe



%%%%%%%4.1.2 

Steady_timeP=stepinfo(Tmd_BFp,'SettlingTimeThreshold',0.05);		%le temps qu il faut le système soit stable

%%sisotool(Tmd_BFp);

%{
rlocus(Tmd_BFp);		%root locus, lieux d Evans
axis('equal');
grid;		%readable
[k,poles]=rlocfind(Tmd_BFp);	%trouver la valeur du point
sgrid(Zeta,frequence);
%}

Zeta = 0.7;			%damping ratio, taux d amortissement, overshoot



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	4.2	Fontion de transfert discrétisée avec correcteur PI  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%4.2.1 Fonction de transfert en BF continue T1 d apres CdC

TauxPI=24.4e-3		% constante de temps en BF
k1=1;				% gain statique
num1=[k1];
den1=[TauxPI 1];
T1=tf(num1,den1,'variable','p');

T1d=c2d(T1,Te);		%Fonction de transfert discretisée
%hold on




%%%%%%%4.2.2 Calcul des coeficients du correcteur PI

Alpha=exp(-Te/TauxPI);
B1=1-Alpha;
% gain statique du système désiré

r0pi=B1/b1;
r1pi=r0pi*a1; 

numPI=[r0pi r1pi];
denPI=[1 -1];
Kpi=tf(numPI,denPI,Te,'variable','z');	%Fonction de transfert du correcteur PI


%%%%%%%4.2.3 Fonction de transfert en BF avec un correcteur PI

Tmd_BOpi=series(Kpi,Tmd);	%Fct de transfert BO ac gain PI
Tmd_BFpi=feedback(Tmd_BOpi,1);

%%step(T1,T1d,Tmd_BFpi);
%%Steady_timePI=stepinfo(Tmd_BFpi,'SettlingTimeThreshold',0.05)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	4.3	Fontion de transfert discrétisée avec correcteur PID
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Determination FT discrétisée d apres Cdc
w1=1/TauxBO;
m=0.707;


%%%%%%%%4.3.1 
%Déterminer la fonction de transfert discrétisée de T_BFPID(z)
num3=[1];
den3=[(1/w1)^2 (2*m)/w1 1];
T2=tf(num3,den3,'variable','p');


T2d=c2d(T2,Te);

T3d_BO=series(T2d,Tmd);
T_BFpid=feedback(T3d_BO,1)

%%%%%%%%4.3.2 
%Déterminer les coefficients du correcteur
%  0.0008615 z^-2 + 0.0007821 z^-3
%  ----------------------------------
%  1 - 2.527(p1) z^-1 + 2.144(p2) z^-2 - 0.6089(p3) Z^-3
% Trouver p1,p2,p3

p1=-2.527;
p2=2.144;
p3=-0.6089;

r0pid=(1-a1+p1)/b1
r1pid=(p2+a1)/b1
r2pid=p3/b1

numPID=[r0pid r1pid r2pid];
denPID=[1 -1 0];
Kpid=tf(numPID,denPID,Te,'variable','z');

%%%%%%%%4.3.3
%Déterminer la réponse à échelon de le temps de réponse à 5%.

Steady_timePID=stepinfo(T_BFpid,'SettlingTimeThreshold',0.05)




%{
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
%}