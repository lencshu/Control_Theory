clear all;
clc;


% parmatres du moteur DC 
r=2;            % Rsistance d induit S.I
k=0.1;          % constante de vitesse et de couple du moteur SI
f=0.2;          % frottement visqueux
j= 0.02;        % Inertie de l arbre moteur
l=0.5;          %inductance de l induit

% Fonction de tranfert  continue
T0=k/(r*f+k*k);             %gain statique
w0=sqrt((f*r+k*k)/(l*j));   %pulsation naturelle, boucle ouvert
m0=(l*f+r*j)/(r*f+k*k)*(w0/2);  %damping ratio, taux d amortissement
num0=[T0];
den0=[1/(w0*w0) 2*m0/w0 1];
Tm=tf(num0,den0,'variable','p');    % Tm fonction de transfert continue

% Fontion de transfert discrtise sans correcteur
Te=10e-3;           %Periode d'chantillonnage d'aprs CdC
Tmd=c2d(Tm,Te)      % Tmd fonction de transfert discrtise
Tauxp = stepinfo(Tmd,'RiseTimeLimits',[0,0.63])       %la constante de temps Tp du systme sans correcteur en boucle ouvert
zpk(Tmd,'v')        %Pour voir ou sont les poles ( 'v') est la car c'est une output

%Coefs de TF moteur
b1=Tmd.num{1}(2)
b2=Tmd.num{1}(3)
a1=Tmd.den{1}(2)
a2=Tmd.den{1}(3)

%Fontion de transfert discrtise avec correcteur P 
rlocus(Tmd);axis('equal');grid; % l'encadrement de K (0<K<intersectione): 0<gain<200
% [k,poles]=rlocfind(Tmd_BFp); %trouver la valeur du point
% sisotool(Tmd);

%on choisit la valeur de K
K=12; 

Tmd_B0p=series(K,Tmd);          %correcteur P en serie 
Tmd_BFp=feedback(Tmd_B0p,1);    %boucle ferme

step(Tmd_BFp);      %afficher le step graphe
Steady_timeP=stepinfo(Tmd_BFp,'SettlingTimeThreshold',0.05)

%lieux d Evans
%sisotool(Tmd_BFp);

%correcteur PID filtre
w1=4*w0;    %pulsation de BF d aprs CdC
m1=0.707;   %damping ratio, taux d amortissement, overshoot
num1=[1];
den1=[(1/w1)^2 (2*m1)/w1 1];
T1=tf(num1,den1,'variable','p');
T1d=c2d(T1,Te);     %Determination T1d(z)

%Coefs du correcteir PID
[P]=T1d.den{1};
p1PID=P(2);
p2PID=P(3);
r0pid=(1+p1PID+p2PID)/(b1+b2);
r1pid=a1*r0pid;
r2pid=a2*r0pid;
s1=r0pid*b2-p2PID;

%Fonction de transfert du correcteur PID filtre
numPID=[r0pid r1pid r2pid];
denPID=conv([1 -1],[1 s1]);
%denK=[1 s1-1 -s1]
Kpid=tf(numPID,denPID,Te,'variable','z');

%La reponse a 5%
Tmd_BOpid=series(Kpid,Tmd)
Tmd_BFpid=feedback(Tmd_BOpid,1)
Steady_timePID=stepinfo(Tmd_BFpid,'SettlingTimeThreshold',0.05)

step(T1,T1d,Tmd_BFpid)




%{
%%%%%%%%%%%%
Mise en place d'un correceteur polynomial 1er cas erreur de position nulle 
%%%%%%%%%%%%
%}

%Détermination N+,N-,D+,D-,Sm
% [Z0d,P0d,k0]=zpkdata(Tmd)
[Z0,k0]=zero(Tmd)
Nstable=tf(k0*[1 -Z0],1,Te)	% N+(z)
Dstable=tf(Tmd.den{1},1,Te)
Sm=1

% Résolution de l'eq diophantienne
%Détermination de O(z) et PI(z) 
%O(z)=o0+o1*^-1   et PI(z)=pi0
%%%%%%%%%需要计算！
pi0=1
o0=p1PID+pi0
o1=p2PID

% Réalisation du correceur Kp(z)
%printsys('z',Sr)
Sr=[1 -1 0] % =(1-z^-1)*z^-2
TSr=tf(1,Sr,Te)
Ttheta=tf([o0 o1],1,Te)
Kp=Ds*Sm*Ttheta*TSr*1/Ns

% Extraction Simulink
NKep=Kp.num{1}
DKep=Kp.den{1}


%{
%%%%%%%%%%%%
 Mise en place d'un correceteur polynomial 2ème cas erreur de vitesse nulle il faut deux intégrateurs
Sr1=(1-z^-1)^2                       
%%%%%%%%%%%%
%}

% Résolution de l'eq diophantienne
%Détermination de O1(z) et PI1(z) 
%O1(z)=o10+o11*^-1   et PI(z)=pi10
pi10=1
o10=p1PID+2*pi10
o11=p2PID-pi10


% Réalisation du correceur Kp1(z) 
Ttheta1=tf([o10 o11],1,Te)
Sr1=[1 -2 1]        % Annule l'erreur de vitesse- deux intégrateurs
TSr1=tf(1,Sr1,Te)   % fonction de transfert de Sr1
Kp1=Ds*Sm*Ttheta1*TSr1*1/Ns


% Extraction Simulink
NKp1=Kp1.num{1}
DKp1=Kp1.den{1}

NP=T0d.num{1}
DP=T0d.den{1}

%{

%待研究
num2=[1];
den2=[1 0];
Gamma_statique=tf(num2,den2,Te,'variable','z');

Ks=(Gamma_statique)/(Tmd*(1-Gamma_statique));   %FT de statique

T_statique_pile_bo=series(Ks,Tmd);
T_statique_pile_bf=feedback(T_statique_pile_bo,1);
step(T_statique_pile_bf,T1d,Tmd_BFpid);
Steady_timestatique=stepinfo(T_statique_pile_bf,'SettlingTimeThreshold',0.05);

%Erreur vitesse nulle
num3=[2 -1];
den3=[1 0 0];
Gamma_trainage=tf(num3,den3,Te,'variable','z');
Kt=(Gamma_trainage)/(Tmd*(1-Gamma_trainage)); %FT de tranage
%}