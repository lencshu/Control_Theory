

###2 Précision statique
####2.1 Précision en l'absence de perturbation
#####2.1.1 Réponse à un échelon
#####2.1.2 Réponse à une rampe
#####2.1.3 Réponse en accélération
#####2.1.4 Bilan
####2.2 Précision en présence de perturbations
####2.3 Conclusions

## IV) 采样系统应用
systèmes échantillonnés
###1 Introduction
###2 Choix de la période d'échantillonnage
####2.1 Considérations pratiques
####2.2 Application à un premier ordre
####2.3 Application à un second ordre
####2.4 Exemples de choix de période d'échantillonnage
###3 Modèle mathématique des systèmes échantillonnés
####3.1 Forme générale
#####3.1.1 Système du premier ordre muni d'un BOZ
#####3.1.2 Système du second ordre muni d'un BOZ
####3.2 Forme générale avec intégrateur
#####3.2.1 Fonction de transfert d'un intégrateur
#####3.2.2 Forme générale
####3.3 Modèle échantillonné du premier ordre
#####3.3.1 Comportement statique
#####3.3.2 Comportement dynamique
####3.4 Modèle échantillonné du second ordre
#####3.4.1 Cas où les pôles sont réels
#####3.4.2 Cas où les pôles sont complexes

## V) PID 采样控制
Commande par PID, approché échantillonné
###1.Introduction
####1.1Choix de la période d'échantillonnage
####1.2Choix de la méthode de discrétisation
###2.Discrétisation des correcteurs.
<p align="center">![](C:\Users\lencs\Desktop\MC59\git.control_theory\images\cap_20171214_103953.png)</p>
####2.1Régulateur PI numérique
Le régulateur PI a pour transformée de Laplace :
<p align="center">![](C:\Users\lencs\Desktop\MC59\git.control_theory\images\cap_20171214_104148.png)</p>
<p align="center">![](C:\Users\lencs\Desktop\MC59\git.control_theory\images\cap_20171214_104327.png)</p>

####2.2Régulateur PID numérique.
La transmittance de Laplace d'un PID est :
<p align="center">![](C:\Users\lencs\Desktop\MC59\git.control_theory\images\cap_20171214_104414.png)</p>
- Cette structure n'est pas la meilleure à cause de la dérivée qui amplifie le bruit dans les hautes fréquences. Dans ce cas, il est préférable d'utiliser un correcteur PID filtré. Cependant, à titre illustratif, nous donnons le calcul de la discrétisation de ce PID. 
<p align="center">![](C:\Users\lencs\Desktop\MC59\git.control_theory\images\cap_20171214_104539.png)</p>

####2.3Régulateur PID filtré numérique.
由于微分器的存在放大了噪声，所以这个结构不是最好的，需要加入PID滤波器
La transmittance de Laplace d'un PID filtré est la suivante : 
<p align="center">![](C:\Users\lencs\Desktop\MC59\git.control_theory\images\cap_20171214_104806.png)</p>
<p align="center">![](C:\Users\lencs\Desktop\MC59\git.control_theory\images\cap_20171214_104839.png)</p>

###3.Discrétisation du processus
####3.1Préambule.
Un processus continu piloté par une unité de calcul recevra sur son entrée une commande qui sera  maintenue  constante  entre  deux  instants  d'échantillonnage.  A  cette  réalité  technologique correspond un schéma d'échantillonnage faisant apparaître un échantillonneur d'ordre zéro.
La structure des correcteurs PID avec un réglage par placement des pôles n'autorise que des processus du premier et second ordre. Nous allons ici développer la discrétisation.

!!! hint ""
	带有放置极点位置的调节器的PID只能用在1阶和2阶过程上

####3.2Processus du premier ordre.
<p align="center">![](C:\Users\lencs\Desktop\MC59\git.control_theory\images\cap_20171214_112055.png)</p>
P (z) : Fonction de transfert du système muni d'un échantillonneur bloqueur d'ordre zéro.
<p align="center">![](C:\Users\lencs\Desktop\MC59\git.control_theory\images\cap_20171214_112316.png)</p>

####3.3Processus du second ordre
<p align="center">![](C:\Users\lencs\Desktop\MC59\git.control_theory\images\cap_20171214_112430.png)</p>
P(z) peut se mettre sous la forme :
<p align="center">![](C:\Users\lencs\Desktop\MC59\git.control_theory\images\cap_20171214_112507.png)</p>

#####3.3.1 Cas des pôles doubles
#####3.3.2 Cas des pôles doubles.
#####3.3.3 Cas des pôles réels8
###4.Commande d'un premier ordre par un P.I.
####4.1 Comportement en premier ordre.
#####4.1.1 Choix du comportement en boucle fermée.
####4.2 Comportement en second ordre
####4.3 Résumé du réglage d'un correcteur P.I
#####4.3.1 Dynamique du premier ordre
#####4.3.2 Dynamique du second ordre.
###5 Commande d'un second ordre par un PID filtré.
####5.1 Comportement du second ordre11 
###6.Conclusion
<p align="center">![](C:\Users\lencs\Desktop\MC59\git.control_theory\images\cap_20171214_110711.png)</p>


## TD习题
###TD03

###TD04
####Ex01
<p align="center">![](C:\Users\lencs\Desktop\MC59\git.control_theory\images\cap_20171130_121908.png)</p>

###TD05

- Objectifs   :
    - Modéliser un système.
    - Établir la fonction de transfert du système. 
    - Étudier différents correcteurs numériques. 
    - Utiliser les outils Matlab, pour mener à bien l'étude.
    - Utiliser les outils Simulink , pour mener à bien l'étude.

####Ex01 Présentation du système :
Le  système  à  asservir  en  vitesse  est  moteur  à  courant  continu  dont  les  caractéristiques  sont  les suivantes :
<p align="center">![](C:\Users\lencs\Desktop\MC59\git.control_theory\images\cap_20171214_114459.png)</p>

- R: résistance de l'induit
- L: inductance de l'induit (que nous négligerons)
- J: inertie ramenée sur l'arbre moteur
- T$_{r}$ : couple résistant exercé par la charge mécanique (ici égal à zéro) 
- K$_{e}$ : constante de vitesse du moteur
- K$_{I}$ : constante de couple du moteur
- f: frottement fluide (coéfficient de frottement visqueux)

建模

- [x] 1.Equation électrique:
	+ $V(t) = R.i(t) + L\frac{di(t)}{dt} + \overbrace{ K_{e}.\Omega(t)}^{Force.ElectroMotrice}$

- [x] 2.Equation mécanique:
	+ $J.\frac{d\Omega(t)}{dt} = \overbrace{K_{I}.i(t)}^{moment.couple.electromagnetique} - \overbrace{ f.\Omega(t)}^{Perte} - C_{charge}(t)$

[补充图片](C:\Users\lencs\Desktop\MC59\git.control_theory\images\cap_20171214_115623.png)
[补充解释](C:\Users\lencs\Desktop\MC59\git.control_theory\images\cap_20171214_115736.png)


计算步骤:
<p align="center">![](C:\Users\lencs\Desktop\MC59\git.control_theory\images\cap_20171214_121053.png)</p>

~~~matlab
r=2;        % Résistance d induit S.I
k=0.1;      % constante de vitesse et de couple du moteur SI
f=0.2;      % frottement visqueux
j=0.02;     % Inertie de l arbre moteur
l=0.5;		% inductance de l induit (que nous négligerons)
~~~

####Ex02 Fonction de transfert continue
<p align="center">![](C:\Users\lencs\Desktop\MC59\git.control_theory\images\cap_20171214_114939.png)</p>

~~~matlab
TauxBO=(r*j)/(r*f+k^2);			% constante de temps du système
k0=k/(r*f+k^2);					% gain statique
w0=1/TauxBO;					% pulsation naturelle, boucle ouvert
frequence=w0/(2*pi);			% fréquence naturelle,w=2*pi*fréquence

num0=[k0];
den0=[TauxBO 1];
Tm=tf(num0,den0,'variable','p')    % Tm fonction de transfert continue
~~~

!!! note "Output"
	Tm = `0.2439 / (0.09756 p + 1)`

####Ex03 Discrétisation du processus
La période d'échantillonnage du processus à discrétiser est Te choisie est de 50ms.

- 3.1 Justifier le choix de la période d'échantillonnage.
Le processus est discrétisé avec un échantillonneur d'ordre zéro.
<p align="center">![](C:\Users\lencs\Desktop\MC59\git.control_theory\images\cap_20171214_122039.png)</p>


~~~matlab
Te=20e-3;			% pédiode d échantillonnag d après CdCh
Tmd=c2d(Tm,Te)		% Tmd fonction de transfert discrétisée

%la constante de temps du système sans correcteur en boucle ouvert
Tauxp = stepinfo(Tmd,'RiseTimeLimits',[0,0.63])
~~~

!!! note "Tauxp"
	RiseTime: 0.08
	SettlingTime: 0.4
	SettlingMin: 0.156391105998548
	SettlingMax: 0.243902416439551
	Overshoot: 0
	Undershoot: 0
	Peak: 0.243902416439551
	PeakTime: 1.58

- 3.2 Établir la fonction de transfert du moteur : 
<p align="center">![](C:\Users\lencs\Desktop\MC59\git.control_theory\images\cap_20171214_122711.png)</p>

~~~matlab
zpk(Tmd,'v')			% Pour voir ou sont les poles ( 'v') est la car c est une output
b1=Tmd.num{1}(2);				% coefficient numérateur de Tmd
a1=T0d.den{1}(2);				% coefficient dénonominateur de Tmd
~~~

!!! note "Output"
	b1 = 0.0978058012558279
	a1 = -0.598996214851105

####Ex04 Étude de différents correcteurs
<p align="center">![](C:\Users\lencs\Desktop\MC59\git.control_theory\images\cap_20171214_122831.png)</p>

#####4.1 Correcteur proportionnel : K (z)=K
- 4.1.1 Étudier la stabilité du correcteur proportionnel en fonction de son gain K.

~~~matlab
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
step(Tmd_BFp);		%afficher le step graphe
~~~

- 4.1.2 Tracer les lieux d’Evan dans le plan complexe z. Commenter. 

~~~matlab
Steady_timeP=stepinfo(Tmd_BFp,'SettlingTimeThreshold',0.05);		%le temps qu il faut le système soit stable

sisotool(Tmd_BFp);

%{
rlocus(Tmd_BFp);		%root locus, lieux d Evans
axis('equal');
grid;		%readable
[k,poles]=rlocfind(Tmd_BFp);	%trouver la valeur du point
sgrid(Zeta,frequence);
%}


~~~

!!! note "Commenter"
	Faut que le point reste dans le circle

#####4.2 Correcteur PI :
<p align="center">![](C:\Users\lencs\Desktop\MC59\git.control_theory\images\cap_20171214_124530.png)</p>
Nous choisissons comme comportement en boucle fermé un système du premier ordre avec une
constante de temps en boucle fermée de 24,4 ms.
<p align="center">![](C:\Users\lencs\Desktop\MC59\git.control_theory\images\cap_20171214_124615.png)</p>

- 4.2.1 Déterminer la fonction de transfert discrétisée de T$_{BFPI}$(z)

- cahier des charges
	+ erreur position nulle
	+ constante de temps de 24.4 ms
	+ gain unitaire


~~~matlab
TauxPI=24.4e-3		% constante de temps en BF
k1=1;				% gain statique
num1=[k1];
den1=[TauxPI 1];
T1=tf(num1,den1,'variable','p');

T1d=c2d(T1,Te);		%Fonction de transfert discretisée
%hold on
~~~

- 4.2.2 Déterminer les coefficients du correcteur

~~~matlab
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
Kpi=tf(numPI,denPI,Te,'variable','z');	%Fonction de transfert du correcteur PI

~~~

!!! note "Output"
	Kpi = `(8.907z-5.335)/(z-1)`

- 4.2.3 Déterminer la réponse à échelon de le temps de réponse à 5%.

~~~matlab
%确定闭环转换函数
Tmd_BOpi=series(Kpi,Tmd);	%Fct de transfert BO ac gain PI
Tmd_BFpi=feedback(Tmd_BOpi,1);

step(T1,T1d,Tmd_BFpi);
Steady_timePI=stepinfo(Tmd_BFpi,'SettlingTimeThreshold',0.05)
~~~

!!! note "Output"
	RiseTime: 0.05
    SettlingTime: 0.1
	SettlingMin: 0.983400133996619
	SettlingMax: 1
	Overshoot: 2.22044604925031e-14
	Undershoot: 0
	Peak: 1
	PeakTime: 0.9

- 4.2.4 Déterminer l'erreur de position et l'erreur de vitesse. 



#####4.3 Correcteur PID :
<p align="center">![](C:\Users\lencs\Desktop\MC59\git.control_theory\images\cap_20171214_154739.png)</p>

Nous choisissons comme comportement en boucle fermé un système du second ordre avec une
pulsation naturelle (ou propre) $\omega_{1}$=1/$\tau_{BO}$ et de coefficient d'amortissement m=0,707.
<p align="center">![](C:\Users\lencs\Desktop\MC59\git.control_theory\images\cap_20171214_155151.png)</p>

~~~matlab
%给定的条件
%Determination FT discrétisée d apres Cdc
w1=1/TauxBO
m=0.707; %damping ratio, taux d amortissement, overshoot

~~~

- 4.3.1 Déterminer la fonction de transfert discrétisée de T$_{BFPID}$(z)

~~~matlab
num3=[1]; % gain statique
den3=[(1/w1)^2 (2*m)/w1 1]

%Fonction de transfert en BF discrétisée
T2=tf(num3,den3,'variable','p');
T2d=c2d(T2,Te)

% Fonction de transfert en BF discrétisée Ordre 3
Td=tf(1,[1 -0.001],Te)
T3d=T2d*Td  % Fonction de transfert d'ordre 3
~~~

- 4.3.2 Déterminer les coefficients du correcteur

~~~matlab hl_lines="1"
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
~~~


- 4.3.3 Déterminer la réponse à échelon de le temps de réponse à 5%.

~~~python hl_lines="2 5"
%Fonction transfert en BO Correcteur + Processus
Tm_BOpid=Kpid*Tmd;   % fonction de transfert en B0

%Fonction transfert en BF Correcteur + Processus
Tm_BFpid=feedback(Tm_BOpid,1);   % fonction de transfert en B0

step(Tmd,Tmd_BFp,Tmd_BFpi,T2,T2d,T3d,Tm_BFpid)   % réponse à un échelon
legend('Tmd','Tmd_BFp','Tmd_BFpi','T2','T2d','T3d','Tm_BFpid')

~~~

- 4.3.4 Déterminer l'erreur de position et l'erreur de vitesse.


~~~matlab hl_lines=""
NPID=Kpid.num{1} % numérateur Kpid
DPID=Kpid.den{1} % dénominateur Kpid

NP=Tmd.num{1}    % numérateur du système en BO
DP=Tmd.den{1}     % dénominateur du sytème en B0
~~~


