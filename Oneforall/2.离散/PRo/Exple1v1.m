%%% correcteur polynomiale %%%

%%%% Fontion de tranfert du processus
num0=[1];
den0=[1 1 0];
F0=tf(num0,den0)
Te=1

%%% dicrétisation du processus
%%% Fod=Z[Bo(p)F0(p)]

F0d=c2d(F0,Te)


F1d=zpk(F0d)
F2d=tf(F0d,Te,'variable','z^-1')


%%% Fonction de transfert du cahier des charges
w1=2*pi()*0.1;
m1=0.4;
T1=1;
num1=[T1];
den1=[1/w1^2 (2*m1/w1)^2 1]
Fm=tf(num1,den1)
Fmd=c2d(Fm,Te)

%%% Réalisation du correcteur K(z)
numK1=[1];
denK1=[0.3679];
K1=tf(numK1,denK1,Te)

numK2=[1 -0.3679];
denK2=[1 0.7183];
K2=tf(numK2,denK2,Te)

numK3=[0.755 -0.4727];
denK3=[1 -1];
K3=tf(numK3,denK3,Te)

K4=K1*K2;
K=K4*K3;

%%% Fontion de transfert en Boucle fermée
FTB0=K*F0d

FTF=feedback(FTB0,1)

%%% Construction de la rampe
numR=[Te 0];
denR=[1 -2 1];
R=tf(numR,denR,Te)  % Construction d'une rampe échantillonnée

Reponse=FTF*R
impulse(Reponse)

%%%% Correcteur

NK=K.num{1} % Numérateur du correcteur
DK=K.den{1} % Denominateur du correcteur

NP=F0d.num{1} % Numérateur du processus
DP=F0d.den{1} % Dénominateur du processus







