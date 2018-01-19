clear all;
clc;

%%%%%%%%%%%% 1er ordre
%建立方程
k0=0.1;

tau0=0.02;
tf0=tf(k0,[tau0 1]);

%数字采样
te=0.015;
% te=0.0025;
tfd0=c2d(tf0,te,'ZOH');
b1a=tfd0.num{1}(2)
a1a=tfd0.den{1}(2)



%correcteur P
% rlocus(tfd0);grid;

Kp_mini=(-1-a1a)/b1a
Kp_maxi=(1-a1a)/b1a

% kp=12;
% tfd0_o=series(kp,tfd0); 
% tfd0_f=feedback(tfd0_o,1)


%一阶系统自动验证采样频率
tau1=tau0/4;

te=0.0025;
Tmin=0.25*tau1;
Tminreel=2*pi/25*tau1
Tmax=1.25*tau1;
Tmaxreel=2*pi/5*tau1
TShannon=pi*tau1

if Tmin<te&&te<Tmax
	fprintf('%f(Tmin) < te < %f(Tmax)\n',Tmin,Tmax)
elseif te<TShannon
	fprintf('Que au Shannon: te<%f(Shannon)\n',TShannon)
else
	fprintf("la periode d'echantillonnage est mal choisie\n")
end


%建立方程
t1=1 %erreur de position==0 所以t1取零
tbf=tau1

tf1=tf(t1,[tau1 1]);

%数字采样
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
tfd0=c2d(tf0,te,'ZOH');
tfd2pi_o=series(Kpi,tfd0);  
tfd2pi_f=feedback(tfd2pi_o,1);

% step(tfd2pi_f)
% step(tf1,tfd1,tfd2pi_f);
Steady_timePI=stepinfo(tfd2pi_f,'SettlingTimeThreshold',0.05)

