%%% Correcteur polynomiale
%%% Exemple 3
%%% CorPolEx4v1.m

%%% Objectifs: R�alisation d'un correcteur polyn�miale qui doit r�ponde
%%% au cahier des charges suivavnts:
%%% dynamique fix�e par un second ordre : w1=1.4 rad/s - m=0.8
%%% Ep: erreur de position nulle - r�ponse � un �chelon
%%% Ev: erreur de vitesse nulle - r�ponsde � une rampe

%%% Le processus analogique a pour caract�ristiques:
%%% w0=0.7 rad/s - m=0.1 - gain statique T0=1

Te=0.72; % P�riode �chantillonnage

%%%% Fontion de tranfert du processus
%%% F(p) avec w0=0.8 rad/s et m=0.1

w0=0.8; % pulsation propre du processus en BO
m=0.1;   % coefficient d'amortissement
T0=1;   % gain statique
num0=[T0];
den0=[1/w0^2 2*m/w0 1];
F0=tf(num0,den0)    % F0(p)
F0d=c2d(F0,Te)      % discr�tisation de la fonction de transfert en BO
T0d=zpk(F0d);
[z0d,p0d,k0]=zpkdata(T0d)
%z0d z�ro de F0d
%p0d p�les de F0d
%k0 gain 


%%% Discr�tisation de la fonction en BF fix� par le cahier des charges

w1=1.4 ; % pulsation propre du processus en BF
m1=0.8;  % coefficient d'amortissement
num1=[1];
den1=[1/w1^2 2*m1/w1 1];
F1=tf(num1,den1)
F1d=c2d(F1,Te) % Discr�tisation de la fonction de transfert en BF 
[z1d,p1d,T1d]=zpkdata(F1d) % liste z�ro - p�le - gain

[D1d]=F1d.den{1} % liste des coefficients du d�nominateur de F1d
% D1d=z^2+D1d(2)*z+D1d(3) - d�nominateur de la fonction de transfert en BF
% R�alisation du correcteur
% Pour cela , il faut d�terminer les polyn�mes O(z) et Pi(z) qui v�rifien l'�quation diophantienne
% N-(z)*O(z)+D-(z)*Sr(z)*Pi(z)=DBF(z) avec PI(0)<>0
% 
% Erreur position nulle , il faut donc un int�grateur Sr=(1-z^-1)
% Erreur de vitesse =0.5 - ev=D-(1)*Ky(1)*PI(1)/DBF(1) pour une rampe Ky(z)=Te
ev=0.5; % erreur de vitesse en r�gime permanent
DBF1=sum(D1d) % =DBF(1)
%%% R�solution du syst�me lin�aire 
%%% O(z)=o0+o1*z-1
%%% PI(z)=p0+p1*z^-1
A=[0 0 1 0;1 0 -1 1;0 1 0 -1;0 0 1 1]
B=[1;D1d(2);D1d(3);ev*DBF1/Te]
Sol=A\B % Solution du syst�me
o0=Sol(1)
o1=Sol(2)
p0=Sol(3)
p1=Sol(4)
O=[o0 o1]; %polyn�me O(z)=o0*z+o1
PI=[p0 p1]; %polun�me PI(z)=p0*z+p1

%%% R�alisation du correcteur K(z)
%%% K(z)=[D+(z)Sm(z)O(z)]/[N+(z)Sr(z)PI(z)]


Sm=1;
numK1=F0d.den{1};
Ds=F0d.den{1} ;
TDs=tf(Ds,1,Te)% D+(z) 
TO=tf(O,1,Te)  % O(z)
Sr=[1 -1];
Tsr=tf(1,Sr,Te) % Sr(z)

z0=zero(F0d);
Ns=k0*[1 -z0]; 

TNs=tf(1,Ns,Te)% 1/N+(z)
TPI=tf(1,PI,Te) % 1/PI(z)
K=TDs*TO*TNs*Tsr*TPI


%%% Extraction simulink

NK=K.num{1}
DK=K.den{1}

NP=F0d.num{1}
DP=F0d.den{1}







