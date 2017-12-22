clear
clc

%Parametres
R=2; k=0.1; f=0.2; J=0.02;L=0.5;

%fct transfert continu du moteur : TF0
T0 = k/(k^2+R*f);
w0=((R*f+k^2)/(L*J))^0.5
m0=0.5*(R*J+L*f)/((L*J*(R*f+k^2))^0.5)
num0=[T0];
den0=[1/(w0^2) 2*m0/w0 1];
TF0=tf(num0, den0, 'variable', 'p');  %TF0 fct transfert continue

%% Partie 3
%fct transfert discrete du moteur
Te=10e-3;              %période d'echantillonnage d'apres CdCh
TF0d = c2d(TF0, Te)    %FT continu en FT discrete

%On reprend les coefficient
a1=-1.866;
a2=0.8694;
b1=0.0004773;
b2=0.0004555;

%% Partie 4
%lieux d'evans
%sisotool(TF0d)

%%%%PID filtré
m1=0.707;
w1=4*w0;

%fct de transfert continu et discrete d'après le cahier des charges
num1 = [1];
den1 = [1/(w1^2) 2*m1/w1 1];
TF1 = tf(num1, den1, 'variable', 'p');  %FT continu en boucle fermé
TF1d = c2d(TF1, Te)                     %FT continu en FT discrete

p1PIDF=-1.641;                          %p1=s1-1+r0*b1
p2PIDF=0.6962;                          %p2=r0*b2-s1;
r0PIDF=(1+p1PIDF+p2PIDF)/(b1+b2);
r1PIDF=a1*r0PIDF;
r2PIDF=a2*r0PIDF;
s1PIDF=r0PIDF*b2-p2PIDF;

%fct transfert du correcteur
numPIDF = [r0PIDF r1PIDF r2PIDF];
denPIDF = [1 s1PIDF-1 -s1PIDF];
Kpidf = tf(numPIDF, denPIDF, Te, 'variable', 'z')

%fct boucle ouvert et fermé, affichage des tracés
TF_PIDF_BO = series(Kpidf, TF0d)
TF_PIDF_BF = feedback(TF_PIDF_BO, 1)
step(TF1, TF1d, TF_PIDF_BF);
stepinfo(TF0d, 'SettlingTimeThreshold', 0.05)
stepinfo(TF_PIDF_BF, 'SettlingTimeThreshold', 0.05)
%}