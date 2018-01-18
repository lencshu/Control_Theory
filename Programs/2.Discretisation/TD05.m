clear all;
clc;

r=2;        % Résistance d induit S.I
k=0.1;      % constante de vitesse et de couple du moteur SI
f=0.2;      % frottement visqueux
j=0.02;     % Inertie de l arbre moteur
l=0.5;      % inductance de l induit (que nous négligerons)

TauxBO=(r*j)/(r*f+k^2);         % constante de temps du système
k0=k/(r*f+k^2);                 % gain statique
w0=1/TauxBO;                    % pulsation naturelle, boucle ouvert
frequence=w0/(2*pi);            % fréquence naturelle,w=2*pi*fréquence

num0=[k0];
den0=[TauxBO 1];
Tm=tf(num0,den0,'variable','p')    % Tm fonction de transfert continue

Te=20e-3;           % pédiode d échantillonnag d après CdCh
Tmd=c2d(Tm,Te)      % Tmd fonction de transfert discrétisée

%la constante de temps du système sans correcteur en boucle ouvert
Tauxp = stepinfo(Tmd,'RiseTimeLimits',[0,0.63])

zpk(Tmd,'v')            % Pour voir ou sont les poles ( 'v') est la car c est une output
b1=Tmd.num{1}(2);               % coefficient numérateur de Tmd
a1=T0d.den{1}(2);               % coefficient dénonominateur de Tmd

%pour trouver valeur l'encadrement de K (0<K<intersection entre ligne bleue et cercle)

sisotool(Tmd); % plus puissant
%rlocus(Tmd);
%zgrid;

%on choisit la valeur de K
K=12; 

%Fct de transfert BO ac gain proportionnel
Tmd_BOp=series(K,Tmd);  

%connection en boucle fermé
Tmd_BFp=feedback(Tmd_BOp,1);    
step(Tmd_BFp);      %afficher le step graphe

Steady_timeP=stepinfo(Tmd_BFp,'SettlingTimeThreshold',0.05);        %le temps qu il faut le système soit stable
sisotool(Tmd_BFp);

TauxPI=24.4e-3      % constante de temps en BF
k1=1;               % gain statique
num1=[k1];
den1=[TauxPI 1];
T1=tf(num1,den1,'variable','p');

T1d=c2d(T1,Te);     %Fonction de transfert discretisée
%hold on

% gain statique du système désiré
%确定B1的第一种方法
Alpha=exp(-Te/TauxPI);
B1=1-Alpha;
%确定B1的第二种方法
B1=T1d.num{1}(2) 
A1=T1d.den{1}(2)

%确定系数
r0pi=B1/b1;
r1pi=r0pi*a1; 

numPI=[r0pi r1pi];
denPI=[1 -1];

%直接转换为Z变换函数
Kpi=tf(numPI,denPI,Te,'variable','z');  %Fonction de transfert du correcteur PI

%确定闭环转换函数
Tmd_BOpi=series(Kpi,Tmd);   %Fct de transfert BO ac gain PI
Tmd_BFpi=feedback(Tmd_BOpi,1);

step(T1,T1d,Tmd_BFpi);
Steady_timePI=stepinfo(Tmd_BFpi,'SettlingTimeThreshold',0.05)

%%%%%%%%%%% PID

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

step(Tmd,Tmd_BFp,Tmd_BFpi,T2,T2d,T3d,Tm_BFpid)   % réponse à un échelon
legend('Tmd','Tmd_BFp','Tmd_BFpi','T2','T2d','T3d','Tm_BFpid')

NPID=Kpid.num{1} % numérateur Kpid
DPID=Kpid.den{1} % dénominateur Kpid

NP=Tmd.num{1}    % numérateur du système en BO
DP=Tmd.den{1}     % dénominateur du sytème en B0

