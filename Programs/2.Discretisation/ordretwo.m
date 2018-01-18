clear all;
clc;

%%%%%%%%% 2eme ordre
k1=25;
tau2=450;
tau3=150;
w3=1/sqrt(tau3*tau2)
m=(tau2+tau3)*w3/2

num5=[k1];
den5=conv([tau2 1],[tau3 1]);
tf3=tf(num5,den5);

te2=60;
tfd3=c2d(tf3,te2,'ZOH')

b1b=tfd3.num{1}(2)
b2b=tfd3.num{1}(3)
a1b=tfd3.den{1}(2)
a2b=tfd3.den{1}(3)


%二阶系统采样频率自动验证
w4=w3*4;
teW4=te2*w4;
m1=0.707;
wc=sqrt(sqrt((2*m^2-1)^2+1)-(2*m^2-1))

Tmin=0.25;
Tminr=2*pi/25
Tmax=1.25;
Tmaxr=2*pi/5
TShannon=pi

if Tmin<teW4&&teW4<Tmax
	fprintf('%f(Tmin) < te < %f(Tmax)\n',Tmin,Tmax)
elseif teW4<TShannon
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


%%%PID filtre
%% 已经是2eme ordre 不需要添加pole
% Fonction de transfert en BF discrétisée Ordre 3
[P2d]=tfd4.den{1} % Tableau contenant les coefficients du dénominateur
p1=P2d(2)
p2=P2d(3)

%Calcul des coefficients du correcteur PID   
r0pid=(1+p1+p2)/(b1b+b2b)
r1pid=a1b*r0pid
r2pid=a2b*r0pid
s1=r0pid*b2b-p2

%Fonction transfert du correcteur PID
numPID=[r0pid r1pid r2pid];	%阶数从左往右依次递减
denPID=conv([1 -1],[1 s1]);
Kdpid=tf(numPID,denPID,te2,'variable','z');

%La reponse a 5%
tfd4_o=series(Kdpid,tfd3)
tfd4_f=feedback(tfd4_o,1)
Steady_timePID=stepinfo(tfd4_f,'SettlingTimeThreshold',0.05)
% step(tf4,tfd4,tfd4_f)
% step(tfd4_f)


%%%%%%Erreur de position

% Extraction Simulink du processus
NPro=tfd3.num{1}
DPro=tfd3.den{1}

%Erreur de position
[Z0,k0]=zero(tfd3)
Nstable=tf(1,k0*[1 -Z0],te2)       % N+(z)
% Nstable=tf([tfd3.num{1}(2) tfd3.num{1}(3)],1,te2)
Dstable=tf(tfd3.den{1},1,te2)
Sm=1

pi0_ep=1
theta0_ep=p1+pi0_ep
theta1_ep=p2

Sr_ep=[1 -1 0] % =(1-z^-1)
TSr_ep=tf(1,Sr_ep,te2)	%=(1-z^-1)*z^-2
Ttheta_ep=tf([theta0_ep theta1_ep],1,te2)
Kp_ep=Dstable*Sm*Ttheta_ep*TSr_ep*1*Nstable

% Extraction Simulink du correcteur EP
Nep=Kp_ep.num{1}
Dep=Kp_ep.den{1}

%%%%%%Erreur de vitesse
pi0_ev=1
theta0_ev=p1+2*pi0_ev
theta1_ev=p2-pi0_ev

% Réalisation du correceur Kp1(z) 
Ttheta_ev=tf([theta0_ev theta1_ev],1,te2)
Sr_ev=[1 -2 1]   %=(1-z^-1)^2
% Annule l'erreur de vitesse - deux intégrateurs = conv([1 -1],[1 -1])
TSr_ev=tf(1,Sr_ev,te2)   % fonction de transfert de Sr_ev
Kp_ev=Dstable*Sm*Ttheta_ev*TSr_ev*1*Nstable

% Extraction Simulink du correcteur EV
Nev=Kp_ev.num{1}
Dev=Kp_ev.den{1}