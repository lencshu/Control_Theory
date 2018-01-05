clear all;
clc;

%%%%%%%%%%%% 1er ordre
%建立方程
k0=0.01;
tau0=60
tf0=tf(k0,[tau0 1]);

%数字采样
te=15;
tfd0=c2d(tf0,te,'ZOH');
b1a=tfd0.num{1}(2)
a1a=tfd0.den{1}(2)

%correcteur P
% rlocus(tfd0);grid;

kp=12;
tfd0_o=series(kp,tfd0); 
tfd0_f=feedback(tfd0_o,1)


%频率加速 一阶系统
tau1=tau0/3;

te=15
Tmin=0.25*tau1;
Tminr=2*pi/25*tau1
Tmax=1.25*tau1;
Tmaxr=2*pi/5*tau1
TShannon=pi*tau1

if Tmin<te&&te<Tmax
	fprintf('%f(Tmin) < te < %f(Tmax)\n',Tmin,Tmax)
elseif te<TShannon
	fprintf('Que au Shannon: te<%f(Shannon)\n',TShannon)
else
	fprintf("la periode d'echantillonnage est mal choisie\n")
end

%建立方程
t1=1
tbf=tau1

tf1=tf(t1,[tau1 1]);

%数字采样
te=15;
tfd1=c2d(tf1,te,'ZOH');
B1a=tfd1.num{1}(2)
A1a=tfd1.den{1}(2)

%5.4 PI
% gain statique du système désiré

r0pi=B1a/b1a
r1pi=r0pi*a1a

numPI=[r0pi r1pi];
denPI=[1 -1];

%直接转换为Z变换函数
Kpi=tf(numPI,denPI,te,'variable','z');  %Fonction de transfert du correcteur PI

%确定闭环转换函数
tfd2pi_o=series(Kpi,tfd0);  
tfd2pi_f=feedback(tfd2pi_o,1);

% step(tf1,tfd1,tfd2pi_f);
Steady_timePI=stepinfo(tfd2pi_f,'SettlingTimeThreshold',0.05)


%%%%%%%%% 2eme ordre
k1=25;
tau2=450;
tau3=150;
w3=1/sqrt(tau3*tau2)
m=(tau2+tau3)*w3/2

den=conv([tau2 1],[tau3 1]);
tf3=tf(k1,den);

te2=60;
tfd3=c2d(tf3,te2,'ZOH')

b1b=tfd3.num{1}(2)
b2b=tfd3.num{1}(3)
a1b=tfd3.den{1}(2)
a2b=tfd3.den{1}(3)


%频率加速 二阶系统
w4=w3*4;
te2c=60*w4;
m1=0.707;
wc=sqrt(sqrt((2*m^2-1)^2+1)-(2*m^2-1))

Tmin=0.25;
Tminr=2*pi/25
Tmax=1.25;
Tmaxr=2*pi/5
TShannon=pi

if Tmin<te2c&&te2c<Tmax
	fprintf('%f(Tmin) < te < %f(Tmax)\n',Tmin,Tmax)
elseif te2c<TShannon
	fprintf('Que au Shannon: te<%f(Shannon)\n',TShannon)
else
	fprintf("la periode d'echantillonnage est mal choisie\n")
end

%采样
num1=[1];
den1=[(1/w4)^2 (2*m1)/w4 1];
tf4=tf(num1,den1,'variable','p');
tfd4=c2d(tf4,te2);     %Determination T1d(z)

B1=tfd4.num{1}(2)
B2=tfd4.num{1}(3)
A1=tfd4.den{1}(2)
A2=tfd4.den{1}(3)


%%%PID

% Fonction de transfert en BF discrétisée Ordre 3
Td=tf(1,[1 -0.001],te2)
tfd5=tfd4*Td  % Fonction de transfert d'ordre 3

[P2d]=tfd5.den{1} % Tableau contenant les coefficients du dénominateur
p1=P2d(2)
p2=P2d(3)
p3=P2d(4)

%Calcul des coefficients du correcteur PID  
r0pid=(1-a1b+p1)/b1b
r1pid=(p2+a1b)/b1b
r2pid=p3/b1b

%Fonction transfert du correcteur PID
numPID=[r0pid r1pid r2pid];
denPID=[1 -1 0];
Kdpid=tf(numPID,denPID,te2,'variable','z')


%La reponse a 5%
tfd5_o=series(Kdpid,tfd4)
tfd5_f=feedback(tfd5_o,1)
Steady_timePID=stepinfo(tfd5_f,'SettlingTimeThreshold',0.05)
% step(tf4,tfd4,tfd5_f)


%%%%%%Erreur de position

[Z0,k0]=zero(tfd4)
Nstable=tf([tfd4.num{1}(2) tfd4.num{1}(3)],1,te2)
Dstable=tf(tfd4.den{1},1,te2)
Sm=1

pi0_ep=1
theta0_ep=p1+pi0_ep
theta1_ep=p2

Sr_ep=[1 -1 0] % =(1-z^-1)
TSr_ep=tf(1,Sr_ep,te2)	%=(1-z^-1)*z^-2
Ttheta_ep=tf([theta0_ep theta1_ep],1,te2)
Kp_ep=Dstable*Sm*Ttheta_ep*TSr_ep*1*Nstable

% Extraction Simulink
NKp_ep=Kp_ep.num{1}
DKp_ep=Kp_ep.den{1}

%%%%%%Erreur de vitesse

pi0_ev=1
theta0_ev=p1+2*pi0_ev
theta1_ev=p2-pi0_ev

% Réalisation du correceur Kp1(z) 
Ttheta_ev=tf([theta0_ev theta1_ev],1,te2)
Sr_ev=[1 -2 1]   
% Annule l'erreur de vitesse - deux intégrateurs = conv([1 -1],[1 -1])
TSr_ev=tf(1,Sr_ev,te2)   % fonction de transfert de Sr_ev
Kp_ev=Dstable*Sm*Ttheta_ev*TSr_ev*1*Nstable

% Extraction Simulink
NKp_ev=Kp_ev.num{1}
DKp_ev=Kp_ev.den{1}

NP=tfd4.num{1}
DP=tfd4.den{1}