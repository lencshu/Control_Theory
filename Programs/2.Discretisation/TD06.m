clear all;
clc;



% parmatres du moteur DC 
r=2;            % Rsistance d induit S.I
k=0.1;          % constante de vitesse et de couple du moteur SI
f=0.2;          % frottement visqueux
j= 0.02;        % Inertie de l arbre moteur
l=0.5;          %inductance de l induit

% Fonction de tranfert continue
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
% rlocus(Tmd);axis('equal');grid; % l'encadrement de K (0<K<intersectione): 0<gain<200
%[k,poles]=rlocfind(Tmd_BFp); %trouver la valeur du point
% sisotool(Tmd);

%on choisit la valeur de K
K=12; 

Tmd_B0p=series(K,Tmd);          %correcteur P en serie 
Tmd_BFp=feedback(Tmd_B0p,1);    %boucle ferme

% step(Tmd_BFp);      %afficher le step graphe
Steady_timeP=stepinfo(Tmd_BFp,'SettlingTimeThreshold',0.05)

%lieux d Evans
% sisotool(Tmd_BFp);

%correcteur PID filtre
w1=4*w0;    %pulsation de BF d aprs CdC
m1=0.707;   %damping ratio, taux d amortissement, overshoot

num1=[1];
den1=[(1/w1)^2 (2*m1)/w1 1];
T1=tf(num1,den1,'variable','p');
T1d=c2d(T1,Te);     %Determination T1d(z)

%Coefs du correcteir PID
[P]=T1d.den{1};	%分母是一维的
p1PID=P(2);		%取第二个数
p2PID=P(3);		%取第三个数
r0pid=(1+p1PID+p2PID)/(b1+b2);
r1pid=a1*r0pid;
r2pid=a2*r0pid;
s1=r0pid*b2-p2PID;

%Fonction de transfert du correcteur PID filtre
numPID=[r0pid r1pid r2pid];	%阶数从左往右依次递减
denPID=conv([1 -1],[1 s1]);
Kpid=tf(numPID,denPID,Te,'variable','z');

%La reponse a 5%
Tmd_BOpid=series(Kpid,Tmd)
Tmd_BFpid=feedback(Tmd_BOpid,1)
Steady_timePID=stepinfo(Tmd_BFpid,'SettlingTimeThreshold',0.05)

% step(T1,T1d,Tmd_BFpid)


%%%%% erreur de position nulle

%Détermination N+,N-,D+,D-,Sm
% [Z0d,P0d,k0]=zpkdata(Tmd)
[Z0,k0]=zero(Tmd)
Nstable=tf(1, k0*[1 -Z0], Te)	
% N+(z) 获取分子 等价于:Nstable=tf([Tmd.num{1}(2) Tmd.num{1}(3)],1,Te)
Dstable=tf(Tmd.den{1},1,Te)
Sm=1

% Résolution de l'eq diophantienne
%Détermination de O(z) et PI(z) 
%O(z)=o0+o1*^-1   et PI(z)=pi0
%%%% WTF？？？？？？
pi0_ep=1
theta0_ep=p1PID+pi0_ep
theta1_ep=p2PID

% Réalisation du correceur Kp(z)
%printsys('z',Sr_ep)
Sr_ep=[1 -1 0] % =(1-z^-1)
TSr_ep=tf(1,Sr_ep,Te)	%=(1-z^-1)*z^-2
Ttheta_ep=tf([theta0_ep theta1_ep],1,Te)
Kp_ep=Dstable*Sm*Ttheta_ep*TSr_ep*1*Nstable

% Extraction Simulink
NKp_ep=Kp_ep.num{1}
DKp_ep=Kp_ep.den{1}


%%%%%erreur de vitesse nulle
pi0_ev=1
theta0_ev=p1PID+2*pi0_ev
theta1_ev=p2PID-pi0_ev

% Réalisation du correceur Kp1(z) 
Ttheta_ev=tf([theta0_ev theta1_ev],1,Te)
Sr_ev=[1 -2 1]   
% Annule l'erreur de vitesse - deux intégrateurs = conv([1 -1],[1 -1])
TSr_ev=tf(1,Sr_ev,Te)   % fonction de transfert de Sr_ev
Kp_ev=Dstable*Sm*Ttheta_ev*TSr_ev*1*Nstable

% Extraction Simulink
NKp_ev=Kp_ev.num{1}
DKp_ev=Kp_ev.den{1}

NP=Tmd.num{1}
DP=Tmd.den{1}