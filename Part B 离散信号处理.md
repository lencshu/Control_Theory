
####3.4 Modèle échantillonné du second ordre

La transformée en Z utilisé le changement de variable en $z=e^{pT_{e}}$, ce qui implique obligatoirement que tous les pôles de la fonction de transfert F(p) se transforme en $z_{i}=e^{p_{i}T_{e}}$ 

#####3.4.1 Cas où les pôles sont réels
<p align="center">![](C:\Users\lencs\Desktop\MC59\git.control_theory\images\cap_20171224_002246.png)</p>

- Gain statique : $G(0)=\underset{Z\rightarrow1}{lim} F(z)$
- Comportement dynamique :
	+ les pôles $Z_{i}$ 越靠近1，对应的$P_{i}$越趋近原点(`grande constante de temps`) $\Rightarrow$ 系统反应越缓慢
	+ 反之 les pôles $Z_{i}$ 越靠近原点，系统反应越快、
	+ L'influence du zéro `零点的影响`：
		* si -1<z$_{0}$<0, le zéro change peu de chose.
		* Plus z$_{0}$ se rapproche des pôles, plus le temps de montée diminue. La réponse est plus nerveuse.
		* Si $z_{i}<z_{0}<1$, la réponse présente un dépassement, d'autant plus important que z$_{0}$ est proche de 1.


#####3.4.2 Cas où les pôles sont complexes
<p align="center">![](C:\Users\lencs\Desktop\MC59\git.control_theory\images\cap_20171224_154246.png)</p>


- Gain statique : $G(0)=\underset{Z\rightarrow1}{lim} F(z)$
- Comportement dynamique


## V) PID 采样控制
Commande par PID, approché échantillonné
###1.Introduction

####1.1Choix de la période d'échantillonnage
$\frac{T_{p}}{10} < T_{e} < \frac{T_{p}}{2}$

####1.2Choix de la méthode de discrétisation
[Voir](##序)

###2.Discrétisation des correcteurs.

Pour calculer les fonctions de transfert des correcteurs PI, PID et PID filtré, ces fonctions de transfert en 'z' seront mise sous la forme du rapport de deux polynômes :
<p align="center">![](C:\Users\lencs\Desktop\MC59\git.control_theory\images\cap_20171214_103953.png)</p>
####2.1Régulateur PI numérique
Le régulateur PI a pour transformée de Laplace :
<p align="center">![](C:\Users\lencs\Desktop\MC59\git.control_theory\images\cap_20171224_202529.png)</p>

####2.2Régulateur PID numérique.
<p align="center">![](C:\Users\lencs\Desktop\MC59\git.control_theory\images\cap_20171224_203459.png)</p>

!!! danger "不是最优结构"
	由于微分器的存在放大了噪声，所以这个结构不是最好的，需要加入PID滤波器

	Cette structure n'est pas la meilleure à cause de la dérivée qui amplifie le bruit dans les hautes fréquences. Dans ce cas, il est préférable d'utiliser un correcteur PID filtré. Cependant, à titre illustratif, nous donnons le calcul de la discrétisation de ce PID. 

####2.3 Régulateur PID filtré numérique.
<p align="center">![](C:\Users\lencs\Desktop\MC59\git.control_theory\images\cap_20171224_204611.png)</p>

###3.Discrétisation du processus

####3.1Préambule.

La structure des correcteurs PID avec un réglage par placement des pôles n'autorise que des processus du premier et second ordre. 

!!! hint ""
	带有放置极点位置的调节器的PID只能用在1阶和2阶过程上

####3.2Processus du premier ordre.
<p align="center">![](C:\Users\lencs\Desktop\MC59\git.control_theory\images\cap_20171224_210425.png)</p>



####3.3Processus du second ordre
<p align="center">![](C:\Users\lencs\Desktop\MC59\git.control_theory\images\cap_20171224_211214.png)</p>

!!! note "a1, a2, b1, b2"
	- a1, a2, b1, b2
		+ 1. les pôles complexes
		+ 2. les pôles réels

#####3.3.1 Cas des pôles complexes
<p align="center">![](C:\Users\lencs\Desktop\MC59\git.control_theory\images\cap_20171224_213344.png)</p>

#####3.3.2 Cas des pôles complexes mais c=0
<p align="center">![](C:\Users\lencs\Desktop\MC59\git.control_theory\images\cap_20171224_213505.png)</p>

#####3.3.3 Cas des pôles réels
<p align="center">![](C:\Users\lencs\Desktop\MC59\git.control_theory\images\cap_20171224_214151.png)</p>

###4.Commande d'un premier ordre par un P.I.
La commande d'un premier ordre par un correcteur P.I donne un comportement en boucle fermée du second ordre.
<p align="center">![](C:\Users\lencs\Desktop\MC59\git.control_theory\images\cap_20171224_214816.png)</p>

####4.1 Comportement en premier ordre.
<p align="center">![](C:\Users\lencs\Desktop\MC59\git.control_theory\images\cap_20171224_221803.png)</p>

####4.2 Comportement en second ordre
<p align="center">![](C:\Users\lencs\Desktop\MC59\git.control_theory\images\cap_20171224_222740.png)</p>

####4.3 Résumé du réglage d'un correcteur P.I
#####4.3.1 Dynamique du premier ordre
<p align="center">![](C:\Users\lencs\Desktop\MC59\git.control_theory\images\cap_20171224_223500.png)</p>


#####4.3.2 Dynamique du second ordre.
<p align="center">![](C:\Users\lencs\Desktop\MC59\git.control_theory\images\cap_20171224_224348.png)</p>

#####4.3.3 
<p align="center">![](C:\Users\lencs\Desktop\MC59\git.control_theory\images\cap_20171224_224443.png)</p>

###5 Commande d'un second ordre par un PID filtré.

Ici, le correcteur est du second ordre. Si nous voulons maîtriser complètement le fonctionnement en boucle fermée, le processus devra être du même ordre.

Dans le cas d'un simplification entre les pôles et les zéros du correcteur, le comportement en boucle fermée sera régi par un second ordre.

Dans le cas contraire, nous aurons un quatrième ordre dont les quatre pôles peuvent être fixés. Ce  deuxième cas aboutissant à des relations lourdes à gérer, nous ne traiterons que la première proposition.

!!! hint ""
	- `processus` 和 `correcteur` 的阶数都为`2`


Le schéma-bloc de l'ensemble processus-correcteur est le suivant :

####5.1 Comportement du second ordre
<p align="center">![](C:\Users\lencs\Desktop\MC59\git.control_theory\images\cap_20171224_235715.png)</p>


###6.Conclusion
<p align="center">![](C:\Users\lencs\Desktop\MC59\git.control_theory\images\cap_20171214_110711.png)</p>

Les correcteurs P.I, P.I.D et P.ID filtré ont respectivement une structure fixe du premier ordre et du second ordre. Nous avons, à partir de ces deux structures, montré comment il était possible de régler un processus modélisé par un premier ou second ordre.

Pour un fonctionnement en boucle fermée par l'utilisateur, il est aisé de calculer les expressions des polynômes S(z) et R(z) nécessaires à l'établissement de l'équation récurrente de la commande.

Le  calcul  des  actions  Kp,  Ti,  Td  et  N  n'est  pas  indispensable  pour faire  la  synthèse  du correcteur, leurs calculs dépendront du choix des paramètres de réglages accessibles par l'utilisateur.

Il est possible, à ce niveau, de dévoyer le concept de réglage d'un PID et considérer finalement que les actions accessibles au régleur sont la pulsation propre et le coefficient d’amortissement du système en boucle fermée. Dans ce cas, à partir de la connaissance de ω0  et m, l'unité numérique déterminer R(z) et S(z) à l'aide des relations vues dans ce chapitre et déterminer ensuite l'équation récurrente de la commande.

L'intérêt  de  cette  approche  est  d'offir  au  régleur  un  moyen  de  réglage  simple  présentant seulement  deux actions. Le réglage du coefficient d'amortissement le  dépassement et la pulsation propre fixe le temps de réponse. Il est clair que, dans une approche classique, les quatre réglages Kp, Ti ; Td et N influent tous sur le temps de réponse et le dépassement.

Dans cette synthèsed en temps discret d'un correcteur de type P.ID, il possible que certains valeurs de réglages Kp ;Ti, Td et N soient négatives. Contrairement au cas continu, cela n'implique pas que le correcteur ne soit pas réglables. Vous pouvez for bien appliquer la commande. Il est clair cependant que ; dans ce cas, l'équivalence au continu perd, quelque peu, de sa consistance.

Un dernier point pint qu'il ne faut pas perdre de vu dans une approche en temps discret, c'est le temps qui est discrétisé et qu'il inutile de sur-échantillonner. Vous choisirez donc un pas de calcul le plus grand possible tout en veillant eu respect du théorème de Shannon.

Si vous faites ce choix d'échantillonnage correct, approximativement entre le dixième et la moitié de la constante de temps principale du processus, le calcul des actions du correcteur devra se faire impérativement avec une approche échantillonnée.

##VI) Les équations polynomiales

- 1.Synoptique de l'asservissement
<p align="center">![](C:\Users\lencs\Desktop\MC59\git.control_theory\images\cap_20171225_000349.png)</p>

- 2.Factorisation de la la fonction de transfert
<p align="center">![](C:\Users\lencs\Desktop\MC59\git.control_theory\images\cap_20171225_000929.png)</p>
举例
<p align="center">![](C:\Users\lencs\Desktop\MC59\git.control_theory\images\cap_20171225_004001.png)</p>

- 3.Structure du correcteur numérique
<p align="center">![](C:\Users\lencs\Desktop\MC59\git.control_theory\images\cap_20171225_001804.png)</p>

- 4.Expression de la FTBO(z)
<p align="center">![](C:\Users\lencs\Desktop\MC59\git.control_theory\images\cap_20171225_001912.png)</p>

- 5.Expression de la FTBF(z)
<p align="center">![](C:\Users\lencs\Desktop\MC59\git.control_theory\images\cap_20171225_002216.png)</p>

- 6.Expression de l'erreur en régime permanent
<p align="center">![](C:\Users\lencs\Desktop\MC59\git.control_theory\images\cap_20171225_002332.png)</p>

- 7.总结

!!! hint "套路"
	- Problème: trouver les polynômes $\Theta(z)$ et $\Pi(z)$. Cela revient à résoudre l'équation Diophantienne.
		- On fixe le régime transitoire avec le polynôme $D_{BF}(z)=N^{-}(z)\Theta(z)+ D^{-}(z)S_{r}(z)\Pi(z)$ équation Diophantienne(connue).
		- On fixe le type d'erreur à annuler en régime permanent $S_{r}(z)$(connu).
		- On fixe de plus une valeur à l'erreur d'ordre immédiatement supérieur (possibilité).


###举例
<p align="center">![](C:\Users\lencs\Desktop\MC59\git.control_theory\images\cap_20171225_003749.png)</p>
<p align="center">![](C:\Users\lencs\Desktop\MC59\git.control_theory\images\cap_20171225_005654.png)</p>




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



TD06
1. 建立微分方程
<p align="center">![](C:\Users\lencs\Desktop\MC59\git.control_theory\images\cap_20171222_152831.png)</p>
<p align="center">![](C:\Users\lencs\Desktop\MC59\git.control_theory\images\cap_20171222_155836.png)</p>

3.1 数字化
<p align="center">![](C:\Users\lencs\Desktop\MC59\git.control_theory\images\cap_20171222_155940.png)</p>

~~~matlab hl_lines="1 8 16"
% parmatres du moteur DC 
r=2;            % Rsistance d induit S.I
k=0.1;          % constante de vitesse et de couple du moteur SI
f=0.2;          % frottement visqueux
j= 0.02;        % Inertie de l arbre moteur
l=0.5; 			%inductance de l induit

% Fonction de tranfert  continue
T0=k/(r*f+k*k);				%gain statique
w0=sqrt((f*r+k*k)/(l*j));	%pulsation naturelle, boucle ouvert
m0=(l*f+r*j)/(r*f+k*k)*(w0/2);	%damping ratio, taux d amortissement
num0=[T0];
den0=[1/(w0*w0) 2*m0/w0 1];
Tm=tf(num0,den0,'variable','p');    % Tm fonction de transfert continue

% Fontion de transfert discrtise sans correcteur
Te=10e-3;			%Periode d'chantillonnage d'aprs CdC
Tmd=c2d(Tm,Te)		% Tmd fonction de transfert discrtise
Tauxp = stepinfo(Tmd,'RiseTimeLimits',[0,0.63])       %la constante de temps Tp du systme sans correcteur en boucle ouvert
zpk(Tmd,'v')		%Pour voir ou sont les poles ( 'v') est la car c'est une output
~~~



3.2
<p align="center">![](C:\Users\lencs\Desktop\MC59\git.control_theory\images\cap_20171222_160043.png)</p>

~~~python hl_lines="1"
%Coefs de TF moteur
b1=Tmd.num{1}(2)
b2=Tmd.num{1}(3)
a1=Tmd.den{1}(2)
a2=Tmd.den{1}(3)
~~~

4.1
<p align="center">![](C:\Users\lencs\Desktop\MC59\git.control_theory\images\cap_20171222_160122.png)</p>

~~~python hl_lines="1 14"
%Fontion de transfert discrtise avec correcteur P 
rlocus(Tmd);axis('equal');grid; % l'encadrement de K (0<K<intersectione): 0<gain<200
%[k,poles]=rlocfind(Tmd_BFp); %trouver la valeur du point
% sisotool(Tmd);

%on choisit la valeur de K
K=12; 

Tmd_B0p=series(K,Tmd);			%correcteur P en serie 
Tmd_BFp=feedback(Tmd_B0p,1);	%boucle ferme

step(Tmd_BFp);		%afficher le step graphe
Steady_timeP=stepinfo(Tmd_BFp,'SettlingTimeThreshold',0.05)

%lieux d Evans
sisotool(Tmd_BFp);
~~~


4.2
<p align="center">![](C:\Users\lencs\Desktop\MC59\git.control_theory\images\cap_20171222_160234.png)</p>

~~~python hl_lines="1 9 18 23"
%correcteur PID filtre
w1=4*w0;	%pulsation de BF d aprs CdC
m1=0.707;	%damping ratio, taux d amortissement, overshoot
num1=[1];
den1=[(1/w1)^2 (2*m1)/w1 1];
T1=tf(num1,den1,'variable','p');
T1d=c2d(T1,Te);		%Determination T1d(z)

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
Kpid=tf(numPID,denPID,Te,'variable','z');

%La reponse a 5%
Tmd_BOpid=series(Kpid,Tmd)
Tmd_BFpid=feedback(Tmd_BOpid,1)
Steady_timePID=stepinfo(Tmd_BFpid,'SettlingTimeThreshold',0.05)

step(T1,T1d,Tmd_BFpid)
~~~

5.
<p align="center">![](C:\Users\lencs\Desktop\MC59\git.control_theory\images\cap_20171222_160303.png)</p>

~~~python hl_lines="1"
%待研究
num2=[1];
den2=[1 0];
Gamma_statique=tf(num2,den2,Te,'variable','z');

Ks=(Gamma_statique)/(Tmd*(1-Gamma_statique));	%FT de statique
                                      
T_statique_pile_bo=series(Ks,Tmd);
T_statique_pile_bf=feedback(T_statique_pile_bo,1);
step(T_statique_pile_bf,T1d,Tmd_BFpid);
Steady_timestatique=stepinfo(T_statique_pile_bf,'SettlingTimeThreshold',0.05);

%Erreur vitesse nulle
num3=[2 -1];
den3=[1 0 0];
Gamma_trainage=tf(num3,den3,Te,'variable','z');
Kt=(Gamma_trainage)/(Tmd*(1-Gamma_trainage)); %FT de tranage
~~~

